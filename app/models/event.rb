class Event < ActiveRecord::Base

  default_scope order: :pos

  belongs_to :competition
  belongs_to :discipline

  has_many :entries, :dependent => :destroy
    has_many :dockets, :through => :entries
    has_many :results, :through => :entries

  delegate :distance, :course, :stroke, :mode, :is_relay?, :to => :discipline, :allow_nil => true

  attr_writer :distance, :course, :stroke, :mode

  GENDERS = %w{ F M X }
  STAGES = %w{ P S F }

  validates :age_min, :age_max, :presence => true,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  validates :competition_id, :discipline_id, :presence => true
  validates :day, :presence => true,
    :numericality => { :only_integer => true, :greater_than => 0,
      :less_than_or_equal_to => Proc.new { |event| event.competition.length } }

  validate :age_max_must_not_be_less_than_age_min

  def age_max_must_not_be_less_than_age_min
    if age_max < age_min
      errors.add(:age_max, "must not be less than Age min")
    end
  end

  def age_range
    age_min..age_max
  end

  def date
    competition.date + (day - 1)
  end

  def permits_relay?(relay)
    relay.gender == gender and age_range.include? relay.age_range
  end

  def permits?(docket)
    [docket.gender, 'X'].include? gender and age_range.include? docket.age
  end

  # customize json representation
  def as_json(options = {})
    super(root: false, only: [:id], methods: [:results])
  end

  # list entries for seeding
  def entries_for_seeding
    seeded = entries.group_by(&:seeded?)
    seeded.default = []
    seeded[true].sort_by(&:time) + seeded[false].sort_by(&:no_time)
  end

  # how to distribute swimmers over lanes, starting in the middle,
  # e.g., [0, 1, 2, 3, 4, 5] -> [3, 2, 4, 1, 5, 0].
  def self.lane_code(width, index)
    (width + (-1)**(width + index) * index) / 2
  end

  # how to compute the heat and lane of entry 'index' out of 'total'
  # with given 'width' lanes, the first one at position 'start'.
  # We alternate the slowest swimmer between lane 1 and lane 'width'.
  # We arrange the surplus as heats with width - 1 lanes if possible.
  def seed!(width, start)
    total = entries.count                   # number of entries
    heats = -(-total).div(width)            # number of heats
    narrow, wides = total.divmod heats      # narrow width, number of wides
    base = (narrow + 1) * wides             # number of entries in wides

    entries_for_seeding.each_with_index do |entry, index|

      # compute coordinates: basically, index = heat * width + lane
      if index < base then
        heat, lane = index.divmod(narrow + 1)
      else
        heat, lane = (index - base).divmod narrow
        heat = heat + wides
      end

      # shuffle: fill lanes from the middle, heats in reverse
      lane = Event.lane_code(width, lane)       # distribute
      lane = width - 1 - lane if heat % 2 == 1  # alternate
      heat, lane = heats - heat, lane + start   # shift and reverse heats.

      # update entry
      entry.update_attributes(:heat => heat, :lane => lane)
    end
    update_attribute(:seeded_at, Time.now)
  end

  def seeded?
    seeded_at and (seeded_at > entries.map(&:updated_at).max)
  end

  def unseed
    update_attribute(:seeded_at, nil)
  end

  def heats
    entries.group_by(&:heat)
  end

  def lanes
    entries.group_by(&:lane)
  end

  def qtimes
    return [] unless competition.qualifications.any?
    competition.qualifications.map do |q|
      q.qualification_times.where(discipline_id: discipline, gender: gender).select do |x|
        age_range.include? x.age_range
      end
    end.sum
  end

  def qtimes_by_range
    qtimes.group_by(&:age_range)
  end

  def qualification_age_ranges
    competition.qualifications.any? ? qtimes_by_range.keys : [0..99]
  end

  def listed_results(ages)
    if is_relay? then
      list = results.select { |x| ages.include? x.entry.age_range }
      list.select { |x| x.time and x.time > 0 }.sort_by(&:time) +
        list.select { |x| x.time == 0 }.sort_by { |x| x.entry.name }
    else
      list = results.select { |x| ages.include? x.entry.age }
      list.select { |x| x.time and x.time > 0 }.sort_by(&:time) +
        list.select { |x| x.time == 0 }.sort_by { |x| x.entry.swimmer.birthday }
    end
  end

  # how to put a place on each valid result
  def list!
    qualification_age_ranges.each do |ages|
      list = results.select { |x| ages.include? x.entry.age }
      list = list.select { |x| x.time and x.time > 0 }.sort_by(&:time)
      times = list.map(&:time)
      list.each do |result|
        result.update_attribute(:place, times.index(result.time) + 1)
      end
    end
  end

  def to_s
    "%s. %s %s" % [pos, { 'F' => "Girls", 'M' => "Boys" }[gender], discipline.nickname]
  end

  def nickname
    "%s %s" % [discipline.nickname, { 'P' => 'Pre', 'F' => '' }[stage]]
  end

  def hyv_line
    stroke_no = {
      "Freestyle" => 1,
      "Backstroke" => 2,
      "Breaststroke" => 3,
      "Butterfly" => 4,
      "Ind Medley" => 5,
    }[stroke]
    age_top = age_max == 99 ? 0 : age_max
    "#{pos};#{stage};#{gender.upcase};#{mode};#{age_min};#{age_top};" +
      "#{distance};#{stroke_no};;;;4;;;;;;"
  end

  def cl2_ages
    lo = age_min == 0 ? "UN" : ("%2d" % age_min)
    hi = age_max == 99 ? "OV" : ("%2d" % age_max)
    lo + hi
  end
end

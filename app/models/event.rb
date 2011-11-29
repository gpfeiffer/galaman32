class Event < ActiveRecord::Base
  belongs_to :competition
  belongs_to :discipline
  has_many :entries, :dependent => :destroy
  has_many :registrations, :through => :entries
  has_many :results, :through => :entries
  has_many :heats

  default_scope :order => :pos

  attr_accessor :gender, :distance, :course, :stroke

  validates :age_min, :age_max, :competition_id, :discipline_id, :presence => true

  def gender
    if self.discipline
      return self.discipline.gender
    end
  end

  def distance
    if self.discipline
      return self.discipline.distance
    end
  end

  def course
    if self.discipline
      return self.discipline.course
    end
  end

  def stroke
    if self.discipline
      return self.discipline.stroke
    end
  end

  def age_range
    self.age_min..self.age_max
  end

  def permits?(swimmer)
    swimmer.gender == self.discipline.gender and 
      self.age_range.include?(swimmer.age(self.competition.date)) 
  end

  def seeded_entries
    entries.select { |x| x.time > 0 }.sort_by(&:time) +
      entries.select { |x| x.time == 0 }.sort_by { |x| x.swimmer.birthday }.reverse
  end

  def lane_helper(width, index)
    if index % 2 == 0
      width / 2 - index / 2
    else
      width / 2 + (index + 1) / 2
    end
  end

  def to_heats(width = 6)
    list = seeded_entries.in_groups_of(width, false)
    if list.count > 1 and (width - list[-1].count) > 1
      list[-2, 2] = (list[-2] + list[-1]).in_groups(2, false)
    end
    list.reverse!
    list.each do |entries|
      entries.each_index do |index|
        entries[index].lane = lane_helper(width, index)
      end
    end
  end

  def qualification_times
    times = []
    competition.qualifications.each do |qualification|
      times += qualification.qualification_times.select { |x| x.discipline == discipline and age_range.include? x.age_range }
    end
    times.sort_by { |x| [x.age_min, x.time] }
  end

  def qualification_age_ranges
    age_ranges = qualification_times.map { |x| x.age_range }.sort_by(&:first).uniq
    age_ranges << age_range unless age_ranges.any?
    age_ranges
  end

  def listed_results(ages)
    list = results.select { |x| ages.include? x.swimmer.age(competition.date) }
    list.select { |x| x.time > 0 }.sort_by(&:time) + 
      list.select { |x| x.time == 0 }.sort_by { |x| x.entry.swimmer.birthday }
  end
end

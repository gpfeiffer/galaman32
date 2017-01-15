class Result < ActiveRecord::Base
  belongs_to :entry
  has_one :event, through: :entry
  has_one :subject, through: :entry
  has_one :competition, through: :event
  has_many :splits, dependent: :destroy

  delegate :discipline, :swimmer, :name,
    :name_and_ages, :club, :invitation, :age, :group, :distance,
    :course, :date, :distance_course_code, :stroke, to: :entry

  attr_accessor :mins, :secs, :cens

  STAGES = %w{ P S F }

  # validates :entry_id, :presence => true, :uniqueness => true

  ## FIXME: validate to ensure that either comment or time is set, not both.

  def age_in_days
    swimmer.age_in_days(date)
  end

  def gender
    swimmer.gender
  end

  def symbol
    club.symbol
  end

  def as_json(options = {})
    super(root: false, methods: [:age_in_days, :symbol, :name, :gender])
  end

  # revert natural order if one time is 0 or nil
  def <=> other
    mtime = time.nil? ? 0 : time
    otime = other.time.nil? ? 0 : other.time
    if mtime == otime
      name <=> other.name
    else
      mtime * otime == 0 ? otime - mtime : mtime - otime
    end
  end

  # convert between SC and LC
  def conversion
    time + discipline.differential
  end

  def cens
    time % 100 if time
  end

  def secs
    (time / 100) % 60 if time
  end

  def mins
    time / 6000 if time
  end

  def laps
    splits.each_with_index do |split, i|
      split.lap = (i == 0 ? split.time : split.time - splits[i-1].time)
    end
  end

  def qualify
    return nil if time.nil? or time == 0
    best = nil
    entry.competition.qualifications.includes(:qualification_times).map do |q|
      qt = q.qualification_times.where(discipline_id: discipline, gender: gender).select { |x| x.age_range.include? entry.age }.first
      if qt and qt.time > time and (not best or qt.time < best[:time])
        best = { :time => qt.time, :qualification => q }
      end
    end
    return best
  end

  def merit
    qu = qualify
    qu ? qu[:qualification].name : ""
  end

  def to_s
    if time.blank? 
      '-'
    elsif time == 0
      comment.present? ? comment : '0'
    elsif mins > 0
      sprintf('%d:%02d.%02d', mins, secs, cens)
    else
      sprintf('%d.%02d', secs, cens)
    end
  end

  # coordinates: x = date of competition, y = time in milliseconds
  def x
    date
  end

  def y
    time.blank? ? 0 : 10 * time
  end

  def coordinates
    return x, y
  end

  # convert result into FINA points
  def fina_points
    return if time == 0
    fina_base = Qualification.find_by_name("FINA Base")
    base_time = fina_base.qualification_times.where(
      discipline_id: discipline.id, 
      gender: gender
    ).first
    return ((10 * base_time.time.quo(time))**3).to_i if base_time
  end

  # is this result a swimmer's best result up to now?
  def personal_best?
    return false if time.nil? or time == 0 
    old = swimmer.results.group_by(&:discipline)[discipline]
    old = old.select { |x| x.date < date and x.time > 0 }
    old.any? ? time < old.map(&:time).min : true
  end

  # return '*' for first time, centiseconds if PB, and nil otherwise.
  def personal_best
    return nil if time.nil? or time == 0 
    old = swimmer.results.group_by(&:discipline)[discipline]
    old = old.select { |x| x.date < date and x.time > 0 }
    if old.any?
      diff = old.map(&:time).min - time
      diff > 0 ? diff : nil
    else
      0
    end
  end
end


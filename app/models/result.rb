class Result < ActiveRecord::Base
  belongs_to :entry
  has_one :registration, :through => :entry
  has_one :event, :through => :entry

  delegate :discipline, :swimmer, :competition, :to => :entry

  attr_accessor :mins, :secs, :cens

  validates :entry_id, :presence => true

  ## FIXME: validate to ensure that either comment or time is set, not both.

  def cens
    time % 100 if time
  end

  def secs
    (time / 100) % 60 if time
  end

  def mins
    time / 6000 if time
  end

  def qualify
    if time == 0
      return nil
    end
    best = nil
    entry.competition.qualifications.each do |qualification|
      qt = qualification.qualification_times.select { |x| x.discipline == discipline and x.age_range.include? entry.registration.age }.first
      if qt and qt.time > time and (not best or qt.time < best[:time])
        best = { :time => qt.time, :qualification => qualification }
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

  def date
    event.date
  end

  # coordinates: x = date of competition, y = time in milliseconds
  def x
    date
  end

  def y
    10 * time
  end

  def coordinates
    return x, y
  end

  # convert result into FINA points
  def fina_points
    qualification = Qualification.find_by_name("FINA Base")
    base_time = QualificationTime.find_by_qualification_id_and_discipline_id(qualification.id, discipline.id).time
    ((10 * base_time / time.to_f)**3).to_i
  end

  # is this result a swimmer's best result up to now?
  def personal_best?
    return false if time == 0 
    old = swimmer.results.group_by(&:discipline)[discipline]
    old = old.select { |x| x.time > 0 and x.date < date }
    old.any? ? time < old.map(&:time).min : true
  end

  # return '*' for first time, centiseconds if PB, and nil otherwise.
  def personal_best
    return nil if time == 0 
    old = swimmer.results.group_by(&:discipline)[discipline]
    old = old.select { |x| x.time > 0 and x.date < date }
    if old.any?
      diff = old.map(&:time).min - time
      diff > 0 ? diff : nil
    else
      0
    end
  end
end


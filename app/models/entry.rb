class Entry < ActiveRecord::Base
  belongs_to :event
  has_one :competition, :through => :event
  has_one :discipline, :through => :event
  has_one :result, :dependent => :destroy
  belongs_to :heat
  belongs_to :subject, :polymorphic => true

  attr_accessor :mins, :secs, :cens

  validates :event_id, :presence => true

  delegate :invitation, :name, :age, :club, :gender, :number, :to => :subject

  # FIXME: delegate to subject.
  def age_range
    subject.age_range
  end

  def swimmer
    subject.swimmer
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

  # combine distance and course into a number for sorting.
  def distance_course_code
    100 * discipline.distance - discipline.course[0].ord
  end

  def stroke
    discipline.stroke
  end

  def qualify
    if time == 0
      return nil
    end
    best = nil
    self.competition.qualifications.each do |qualification|
      qt = qualification.qualification_times.select { |x| x.discipline == discipline and x.age_range.include? self.age }.first
      if qt and qt.time > time and (not best or qt.time < best[:time])
        best = { :time => qt.time, :qualification => qualification }
      end
    end
    return best
  end

  def to_s
    if time == 0
      'NT'
    elsif mins > 0
      sprintf('%d:%02d.%02d', mins, secs, cens)
    else
      sprintf('%d.%02d', secs, cens)
    end
  end
end

class QualificationTime < ActiveRecord::Base
  belongs_to :qualification
  belongs_to :discipline

  validates :age_min, :age_max, :presence => true, 
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

  validates :qualification_id, :discipline_id, :time, :presence => true

  attr_accessor :mins, :secs, :centis
  attr_accessor :gender, :distance, :course, :stroke

  validate :age_max_must_not_be_less_than_age_min

  def age_max_must_not_be_less_than_age_min
    if age_max < age_min
      errors.add(:age_max, "must not be less than Age min")
    end
  end

  def centis
    if self.time
      return self.time % 100
    end
  end

  def secs
    if self.time
      return (self.time / 100) % 60
    end
  end

  def mins
    if self.time
      return self.time / 6000
    end
  end

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

  def to_s
    if self.mins > 0
      sprintf('%d:%02d.%02d', self.mins, self.secs, self.centis)
    else
      sprintf('%d.%02d', self.secs, self.centis)
    end
  end
end

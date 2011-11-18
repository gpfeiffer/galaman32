class Event < ActiveRecord::Base
  belongs_to :competition
  belongs_to :discipline
  has_many :entries, :dependent => :destroy
  has_many :registrations, :through => :entries
  has_many :results, :through => :entries

  default_scope :order => :pos

  attr_accessor :gender, :distance, :course, :stroke

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

  def age_range_to_s
    if age_min == 0
      if age_max == 99
        'all ages'
      else
        "#{age_max} years and under"
      end
    else
      if age_max == 99
        "#{age_min} years and over"
      else
        "#{age_min} - #{age_max} years"
      end
    end
  end

  def permits?(swimmer)
    swimmer.gender == self.discipline.gender and 
      self.age_range.include?(swimmer.age(self.competition.date)) 
  end
end

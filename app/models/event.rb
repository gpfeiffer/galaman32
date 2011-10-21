class Event < ActiveRecord::Base
  belongs_to :competition
  belongs_to :discipline
  has_many :entries
  has_many :swimmers, :through => :entries

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

  def permits?(swimmer)
    swimmer.gender == self.discipline.gender and 
      self.age_range.include?(swimmer.age(self.competition.date)) 
  end
end

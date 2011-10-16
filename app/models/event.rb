class Event < ActiveRecord::Base
  belongs_to :competition
  belongs_to :discipline
  has_many :entries
  has_many :swimmers, :through => :entries

  def age_range
    self.age_min..self.age_max
  end

  def permits?(swimmer)
    swimmer.gender == self.discipline.gender and 
      self.age_range.include?(swimmer.age(self.competition.date)) 
  end
end

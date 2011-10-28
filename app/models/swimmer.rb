class Swimmer < ActiveRecord::Base
  default_scope :order => [:last, :first]

  belongs_to :club
  has_many :registrations
  has_many :competitions, :through => :registrations
  has_many :entries
  has_many :events, :through => :entries
  has_many :results, :through => :entries

  GENDERS = ["f", "m"]

  def name
    "#{self.last}, #{self.first}"
  end

  def age (dat = DateTime.now)
    if self.birthday == nil
      return 0
    end
    dob = self.birthday
    age = dat.year - dob.year
    if dob + age.years > dat
      age -= 1
    end
    return age
  end

  def personal_best(discipline)
    best = nil
    results.select{ |x| x.discipline == discipline }.each do |result|
      if not best or best.time == 0 or result.time < best.time
        best = result
      end
    end
    return best
  end
end

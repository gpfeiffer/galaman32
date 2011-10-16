class Swimmer < ActiveRecord::Base
  belongs_to :club

  GENDERS = ["f", "m"]

  def name
    "#{self.last}, #{self.first}"
  end

  def age (dat = DateTime.now)
    dob = self.birthday
    age = dat.year - dob.year
    if dob + age.years > dat
      age -= 1
    end
    return age
  end

end

class Relay < ActiveRecord::Base
  belongs_to :invitation
  has_one :club, :through =>:invitation
  has_many :entries, :as => :subject, :dependent => :destroy
  has_many :seats, :dependent => :destroy
  has_many :dockets, :through => :seats

  def age_range
    age_min .. age_max
  end

  def age
    age_max
  end

  def name_and_ages
    "#{name}, #{ages_to_s(age_range)}"
  end

  def number
    "xxx"
  end

  def swimmer
    nil
  end

  # sorting attribute in the absence of time
  def no_time
    [x.age, x.id.hash % 97]  # first by age, then somewhat random
  end

  def permits?(docket)
    seats.count < 4 and docket.swimmer.gender == gender and age_max >= docket.age
  end
end

class Relay < ActiveRecord::Base
  belongs_to :invitation
  has_one :club, :through =>:invitation
  has_many :entries, :dependent => :destroy
  has_many :seats, :dependent => :destroy
  has_many :registrations, :through => :seats

  def age_range
    age_min .. age_max
  end

  def permits?(registration)
    seats.count < 4 and registration.swimmer.gender == gender and age_max >= registration.age
  end
end

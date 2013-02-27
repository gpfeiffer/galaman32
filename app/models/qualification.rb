class Qualification < ActiveRecord::Base
  has_many :qualification_times
  has_many :disciplines, :through => :qualification_times
  has_many :standards
  has_many :competitions, :through => :standards
  has_many :aims

  validates :name, :presence => true, :uniqueness => true

end

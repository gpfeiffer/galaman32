class Qualification < ActiveRecord::Base
  has_many :qualification_times, :dependent => :destroy
  has_many :disciplines, :through => :qualification_times
  has_many :standards, :dependent => :destroy
  has_many :competitions, :through => :standards
  has_many :aims, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => true

end

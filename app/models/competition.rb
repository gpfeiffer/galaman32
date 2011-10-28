class Competition < ActiveRecord::Base
  default_scope :order => 'date'
  has_many :events, :dependent => :destroy
  has_many :disciplines, :through => :events
  has_many :registrations, :dependent => :destroy
  has_many :swimmers, :through => :registrations
end

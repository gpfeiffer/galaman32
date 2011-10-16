class Competition < ActiveRecord::Base
  has_many :events
  has_many :disciplines, :through => :events
  has_many :registrations
  has_many :swimmers, :through => :registrations
end

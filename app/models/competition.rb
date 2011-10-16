class Competition < ActiveRecord::Base
  has_many :events
  has_many :disciplines, :through => :events
end

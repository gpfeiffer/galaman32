class Registration < ActiveRecord::Base
  belongs_to :swimmer
  has_one :club, :through => :swimmer
  belongs_to :competition
  has_many :entries, :dependent => :destroy
  has_many :events, :through => :entries
end

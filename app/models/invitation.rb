class Invitation < ActiveRecord::Base
  belongs_to :club
  belongs_to :competition
  has_many :registrations, :dependent => :destroy
  has_many :swimmers, :through => :registrations

  validates :club_id, :competition_id, :presence => true
end

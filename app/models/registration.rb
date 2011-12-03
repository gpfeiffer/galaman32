class Registration < ActiveRecord::Base
  belongs_to :swimmer
  has_one :club, :through => :swimmer
  belongs_to :invitation
  has_one :competition, :through => :invitation
  has_many :entries, :dependent => :destroy
  has_many :events, :through => :entries

  validates :invitation_id, :swimmer_id, :presence => true
end

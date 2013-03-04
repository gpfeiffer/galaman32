class Registration < ActiveRecord::Base
  belongs_to :swimmer
  delegate :gender, :to => :swimmer
  belongs_to :invitation
  belongs_to :club
  has_one :competition, :through => :invitation
  has_many :entries, :dependent => :destroy
  has_many :events, :through => :entries
  has_many :seats, :dependent => :destroy
  has_many :relays, :through => :seats

  validates :invitation_id, :swimmer_id, :presence => true
  
  before_create :assign_age_and_club
  
  def date
    competition.date
  end

  private
  
  def assign_age_and_club
    self.age = swimmer.age(invitation.competition.date)
    self.club = swimmer.club
  end
end

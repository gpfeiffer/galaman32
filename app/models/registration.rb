class Registration < ActiveRecord::Base
  belongs_to :swimmer
  has_one :club, :through => :swimmer
  belongs_to :invitation
  has_one :competition, :through => :invitation
  has_many :entries, :dependent => :destroy
  has_many :events, :through => :entries
  has_many :seats, :dependent => :destroy
  has_many :relays, :through => :seats

  validates :invitation_id, :swimmer_id, :presence => true

  before_save :compute_and_assign_age_on_the_day

  def gender
    swimmer.gender
  end

  private

  def compute_and_assign_age_on_the_day
    self.age = swimmer.age(invitation.competition.date)
  end
end

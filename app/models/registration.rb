class Registration < ActiveRecord::Base
  belongs_to :swimmer
  belongs_to :invitation
  has_one :competition, :through => :invitation
  has_many :entries, :dependent => :destroy
  has_many :events, :through => :entries
  has_many :seats, :dependent => :destroy
  has_many :relays, :through => :seats

  validates :invitation_id, :swimmer_id, :presence => true
  
  delegate :gender, :name, :to => :swimmer
  delegate :date, :to => :competition

  before_create :assign_age
  
  private
  
  def assign_age
    age = swimmer.age(invitation.competition.date)
  end
end

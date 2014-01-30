class Docket < ActiveRecord::Base
  belongs_to :swimmer
  belongs_to :invitation
  has_one :competition, :through => :invitation
  has_many :entries, :as => :subject, :dependent => :destroy
  has_many :events, :through => :entries
  has_many :seats, :dependent => :destroy
  has_many :relays, :through => :seats

  validates :invitation_id, :swimmer_id, :presence => true
  
  delegate :gender, :name, :first_last, :number, :to => :swimmer
  delegate :date, :to => :competition
  delegate :club, :to => :invitation

  before_create :assign_age
  
  def age_range
    age .. age
  end

  def name_and_ages
    "#{swimmer.first_last}, #{age}"
  end

  # sorting attribute in the absence of time
  def no_time
    swimmer.age_in_days
  end

  private
  
  def assign_age
    self.age = swimmer.age(invitation.competition.date)
  end
end

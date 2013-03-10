class Profile < ActiveRecord::Base
  belongs_to :user
  belongs_to :club
  belongs_to :swimmer

  has_many :ratings, :dependent => :destroy

  validates :user_id, :club_id, :presence => true

  def target
    swimmer or club
  end
end

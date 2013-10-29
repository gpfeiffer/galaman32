class Profile < ActiveRecord::Base
  belongs_to :user
  belongs_to :club
  belongs_to :swimmer

  validates :user_id, :club_id, :presence => true

  def target
    swimmer or club
  end

  def name
    target.name
  end
end

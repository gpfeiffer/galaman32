class Invitation < ActiveRecord::Base
  belongs_to :club
  belongs_to :competition
  has_many :registrations, :dependent => :destroy
  has_many :swimmers, :through => :registrations
  has_many :relays, :dependent => :destroy

  validates :club_id, :competition_id, :presence => true

  def registrations_for_day(day)
    events = competition.events.group_by(&:day)[day]
    registrations.select { |x| (x.events & events).any? }
  end
end

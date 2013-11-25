class Invitation < ActiveRecord::Base
  belongs_to :club
  belongs_to :competition
  has_many :dockets, :dependent => :destroy
  has_many :swimmers, :through => :dockets
  has_many :entries, :through => :dockets
  has_many :relays, :dependent => :destroy

  validates :club_id, :competition_id, :presence => true

  def dockets_for_day(day)
    events = competition.events.group_by(&:day)[day]
    dockets.select { |x| (x.events & events).any? }
  end
end

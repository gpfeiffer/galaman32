class Invitation < ActiveRecord::Base
  belongs_to :club
  belongs_to :competition
  has_many :dockets, :dependent => :destroy
  has_many :swimmers, :through => :dockets
  has_many :entries, :through => :dockets
  has_many :relays, :dependent => :destroy

  validates :club_id, :competition_id, :presence => true

  # number of individual entries
  def i_entries_count 
    dockets.map(&:entries).flatten.count 
  end

  # number of relay entries
  def r_entries_count
    relays.map(&:entries).flatten.count
  end

  def dockets_for_day(day)
    events = competition.events.group_by(&:day)[day]
    dockets.select { |x| (x.events & events).any? }
  end
end

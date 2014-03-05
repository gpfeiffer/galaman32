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
    events = competition.events.group_by(&:day)[day] || []
    dockets.select { |x| (x.events & events).any? }
  end

  # sdif
  def to_c1
    line = {
      :mark => "C1",
      :orgc => "8",
      :gap0 => "%8s" % "",
      :team => "  %-4s" % club.symbol[0,4],
      :name => "%-30s" % club.full_name, 
      :abbr => "%-16s" % "", 
      :adr1 => "%-22s" % "", 
      :adr2 => "%-22s" % "", 
      :city => "%-20s" % "", 
      :stat => "  ", 
      :zipc => "%-10s" % "", 
      :ctry => "   ", 
      :rgon => " ", 
      :gap1 => "%6s" % "",
      :five => "%1s" % club.symbol[4],
      :gap2 => "%10s" % "",
    }
    line = SDIF[line[:mark]][:keys].map { |key| line[key] }.join
    line[-4, 4] = Format.checksum(line)
    line
  end
end

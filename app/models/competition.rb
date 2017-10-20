class Competition < ActiveRecord::Base

  default_scope order: 'date'

  has_many :events, dependent: :destroy
    has_many :disciplines, through: :events
    has_many :entries, through: :events
    has_many :results, through: :events
  has_many :standards, dependent: :destroy
    has_many :qualifications, through: :standards
  has_many :invitations, dependent: :destroy
    has_many :dockets, through: :invitations
      has_many :swimmers, through: :dockets
    has_many :relays, through: :invitations
    has_many :clubs, through: :invitations

  validates :name, :date, :length, presence: true
  validates :course, inclusion: Discipline::COURSES

  def individual_events
    events.select { |x| not x.is_relay? }
  end

  def relay_events
    events.select { |x| x.is_relay? }
  end

  def season
    year = date.year + (date.month > 8 ? 1 : 0)
    return "%d/%02d" % [year-1, year % 100]
  end

  def days
    1..length
  end

  def first_day
    date
  end

  def last_day
    date + (length - 1)
  end

  def dates
    "#{first_day}" + (length > 1 ? " - #{last_day}" : "")
  end

  # which competitions lie ahead of us?
  def relative_date
    [:current, :recent, :future][((Date.today - date)/length).floor <=> 0]
  end

  def to_s
    "%s: %s, %s" % [dates, name, location] 
  end

  def location_dates
    "#{location}, #{dates}"
  end

  # number of individual entries
  def i_entries_count 
    dockets.map(&:entries).flatten.count 
  end

  # number of relay entries
  def r_entries_count
    relays.map(&:entries).flatten.count
  end

  # SDIF parts
  def to_a0
    line = {
      :mark => "A0",
      :orgc => "8",
      :vers => "%-8s" % "V3",
      :filc => "02",
      :gap0 => "%-30s" % "Meet Results",
#      :snam => "%-20s" % "GalaMan",
      :snam => "%-20s" % "Hy-Tek, Ltd",
#      :sver => "%-10s" % "v3.1",
      :sver => "%-10s" % "WMM 4.0Eh",
#      :cnam => "%-20s" % "BlueFin S.C.",
      :cnam => "%-20s" % "Hy-Tek, Ltd",
#      :cpho => "%12s" % "",
      :cpho => "%12s" % "866-456-5111",
      :date => Time.now.strftime("%m%d%Y"),
      :gap1 => "%42s" % "MM40  ",
      :subm => "  ",
      :gap2 => "   ",
    }
    line = SDIF[line[:mark]][:keys].map { |key| line[key] }.join
    line[-4, 4] = Format.checksum(line)
    line
  end

  def to_b1
    line = {
      :mark => "B1",
      :orgc => "8",
      :gap0 => "%8s" % "",
      :name => "%-30s" % name,
      :adr1 => "%-22s" % "",
      :adr2 => "%-22s" % "",
      :city => "%-20s" % location,
      :stat => "%2s" % "",
      :zipc => "%10s" % "",
      :ctry => "%3s" % "",
      :meet => " ",
      :dat0 => date.strftime("%m%d%Y"),
      :dat1 => (date + (length - 1)).strftime("%m%d%Y"),
      :alti => "%4d" % 0,
      :gap1 => "%8s" % "",
      :crse => "S",
      :gap2 => "%-10s" % " 000",
    }
    line = SDIF[line[:mark]][:keys].map { |key| line[key] }.join
    line[-4, 4] = Format.checksum(line)
    line
  end

  def to_z0
    line = {
      :mark => "Z0",
      :orgc => "8",
      :gap0 => "Meet Res",
      :filc => "02",
      :note => "%-30s" % "Successful Build on #{Date.today}",
      :nrbs => "%3s" % 1,
      :nrms => "%3s" % 1,
      :nrcs => "%4s" % invitations.count,
      :nrts => "%4s" % invitations.count,
      :nrds => "%6s" % i_entries_count,
      :nrss => "%6s" % dockets.count,
      :nres => "%5s" % r_entries_count,
      :nrfs => "%6s" % 0,
      :nrgs => "%6s" % 0,
      :btch => "%-5s" % "",
      :news => "%-3s" % "",
      :rens => "%-3s" % "",
      :chgs => "%-3s" % "",
      :dels => "%-3s" % "",
      :gap1 => "%-57s" % "",
    }
    line = SDIF[line[:mark]][:keys].map { |key| line[key] }.join
    line[-4, 4] = Format.checksum(line)
    line
  end

end

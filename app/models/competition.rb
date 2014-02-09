class Competition < ActiveRecord::Base
  default_scope :order => 'date'
  has_many :events, :dependent => :destroy
  has_many :disciplines, :through => :events
  has_many :standards
  has_many :qualifications, :through => :standards
  has_many :invitations, :dependent => :destroy
  has_many :dockets, :through => :invitations
  has_many :relays, :through => :invitations
  has_many :clubs, :through => :invitations

  validates :name, :date, :length, :presence => true

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

  def relative_date
    [:recent, :current, :future][(date <=> Date.today) + 1]
  end

  # which competitions lie ahead of us?
  def self.future
    Competition.where("date > ?", Date.today)
  end

  def self.current
    Competition.where("date = ?", Date.today)
  end
  
  def self.recent(count = 3)
    Competition.where("date < ?", Date.today).reverse.first count
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
end

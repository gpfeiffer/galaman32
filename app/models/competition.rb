class Competition < ActiveRecord::Base
  default_scope :order => 'date'
  has_many :events, :dependent => :destroy
  has_many :disciplines, :through => :events
  has_many :standards
  has_many :qualifications, :through => :standards
  has_many :invitations, :dependent => :destroy
  has_many :registrations, :through => :invitations
  has_many :clubs, :through => :invitations

  validates :name, :date, :presence => true

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

  # which competitions lie ahead of us?
  def self.future
    Competition.where("date >= ?", Time.now)
  end

  def self.recent(count = 3)
    Competition.where("date < ?", Time.now).reverse.first count
  end
end

class Entry < ActiveRecord::Base
  belongs_to :registration
  has_one :swimmer, :through => :registration
  has_one :invitation, :through => :registration
  belongs_to :event
  has_one :competition, :through => :event
  has_one :discipline, :through => :event
  has_one :result, :dependent => :destroy
  belongs_to :heat

  attr_accessor :mins, :secs, :centis

  validates :event_id, :registration_id, :presence => true

  def centis
    time % 100 if time
  end

  def secs
    (time / 100) % 60 if time
  end

  def mins
    time / 6000 if time
  end

  def to_s
    if time == 0
      'NT'
    elsif mins > 0
      sprintf('%d:%02d.%02d', mins, secs, centis)
    else
      sprintf('%d.%02d', secs, centis)
    end
  end
end

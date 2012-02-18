class Entry < ActiveRecord::Base
  belongs_to :registration
  has_one :swimmer, :through => :registration
  belongs_to :event
  has_one :competition, :through => :event
  has_one :discipline, :through => :event
  has_one :result, :dependent => :destroy
  belongs_to :heat
  belongs_to :relay

  attr_accessor :mins, :secs, :centis

  validates :event_id, :presence => true

  # FIXME: validate either registration_id or relay_id is present but not both

  def invitation
    if relay then
      relay.invitation
    else
      registration.invitation
    end
  end

  def name
    relay ? relay.name : swimmer.first_last
  end

  def age
    relay ? relay.age_max : registration.age
  end

  def club
    relay ? relay.club : registration.club
  end

  def subject
    relay ? relay : swimmer
  end

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

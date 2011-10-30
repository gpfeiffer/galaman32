class Entry < ActiveRecord::Base
  belongs_to :swimmer
  belongs_to :registration
  belongs_to :event
  has_one :result, :dependent => :destroy
#  belongs_to :discipline, :through => :event

  attr_accessor :mins, :secs, :centis

  def centis
    if self.time
      return self.time % 100
    end
  end

  def secs
    if self.time
      return (self.time / 100) % 60
    end
  end

  def mins
    if self.time
      return self.time / 6000
    end
  end

  def discipline
    event.discipline
  end

  def to_s
    if self.mins > 0
      sprintf('%d:%02d.%02d', self.mins, self.secs, self.centis)
    else
      sprintf('%d.%02d', self.secs, self.centis)
    end
  end
end

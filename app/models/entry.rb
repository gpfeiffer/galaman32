class Entry < ActiveRecord::Base
  belongs_to :swimmer
  belongs_to :event

  attr_accessor :mins, :secs, :centis

  def centis
    if self.seed_time
      return self.seed_time % 100
    end
  end

  def secs
    if self.seed_time
      return (self.seed_time / 100) % 60
    end
  end

  def mins
    if self.seed_time
      return self.seed_time / 6000
    end
  end

  def to_s
    if self.mins > 0
      sprintf('%d:%02d.%02d', self.mins, self.secs, self.centis)
    else
      sprintf('%d.%02d', self.secs, self.centis)
    end
  end
end

class Result < ActiveRecord::Base
  belongs_to :entry
#  belongs_to :discipline, :through => :entry

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
    entry.discipline
  end

  def to_s
    if self.time == 0
      if self.comment
        self.comment
      else
        '0'
      end        
    elsif self.mins > 0
      sprintf('%d:%02d.%02d', self.mins, self.secs, self.centis)
    else
      sprintf('%d.%02d', self.secs, self.centis)
    end
  end
end

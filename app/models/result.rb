class Result < ActiveRecord::Base
  belongs_to :entry

  attr_accessor :mins, :secs, :centis

  validates :entry_id, :presence => true

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

  def swimmer
    entry.swimmer
  end

  def competition
    entry.competition
  end

  def qualify
    if time == 0
      return nil
    end
    best = nil
    entry.competition.qualifications.each do |qualification|
      qt = qualification.qualification_times.select { |x| x.discipline == discipline and x.age_range.include? entry.registration.age }.first
      if qt and qt.time > time and (not best or qt.time < best[:time])
        best = { :time => qt.time, :qualification => qualification }
      end
    end
    return best
  end

  def merit
    qu = qualify
    qu ? qu[:qualification].name : ""
  end

  def to_s
    if self.time.blank? 
      '-'
    elsif self.time == 0
      if self.comment.present?
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

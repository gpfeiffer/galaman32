class Entry < ActiveRecord::Base
  belongs_to :event
  has_one :competition, :through => :event
  has_one :discipline, :through => :event
  has_one :result, :dependent => :destroy
  belongs_to :subject, :polymorphic => true

  attr_accessor :mins, :secs, :cens

  validates :event_id, :presence => true

  delegate :invitation, :name, :first_last, :age, :club, :gender, :number, :to => :subject

  after_destroy do
    self.event.unseed
  end

  # FIXME: delegate to subject.
  def age_range
    subject.age_range
  end

  def name_and_ages
    subject.name_and_ages
  end

  def swimmer
    subject.swimmer
  end

  # for sorting
  def no_time
    subject.no_time
  end

  def cens
    time % 100 if time
  end

  def secs
    (time / 100) % 60 if time
  end

  def mins
    time / 6000 if time
  end

  def seeded?
    time and time > 0
  end

  # combine distance and course into a number for sorting.
  def distance_course_code
    100 * discipline.distance - discipline.course[0].ord
  end

  def stroke
    discipline.stroke
  end

  def qualify
    if time == 0
      return nil
    end
    best = nil
    self.competition.qualifications.each do |qualification|
      qt = qualification.qualification_times.select { |x| x.discipline == discipline and x.age_range.include? self.age }.first
      if qt and qt.time > time and (not best or qt.time < best[:time])
        best = { :time => qt.time, :qualification => qualification }
      end
    end
    return best
  end

  def to_s
    if time == 0
      'NT'
    elsif mins > 0
      sprintf('%d:%02d.%02d', mins, secs, cens)
    else
      sprintf('%d.%02d', secs, cens)
    end
  end

  # sdif
  def to_d0
    line = {
      :mark => "D0",
      :orgc => "8",
      :gap0 => "%-8s" % "",
      :name => "%-28s" % swimmer.last_first,
      :siid => "%-12s" % swimmer.number,
      :atch => "A",
      :citz => "%-3s" % "",
      :dofb => "%8s" % swimmer.birthday.strftime("%m%d%Y"),
      :agen => "%2d" % subject.age,
      :ssex => "%1s" % subject.gender.upcase,
      :esex => "%1s" % event.gender.upcase,
      :dist => "%4d" % event.distance,
      :stro => "%d" % {
        "Freestyle" => 1,
        "Backstroke" => 2, 
        "Breaststroke" => 3, 
        "Butterfly" => 4, 
        "Ind Medley" => 5,
      }[stroke],
      :evnt => "%3d%1s" % [event.pos, "ABCDE"[event.qualification_age_ranges.find_index{ |r| r.include? subject.age }]],
      :ages => "%4s" % event.cl2_ages,
      :date => "%8s" % event.date.strftime("%m%d%Y"),
      :tim0 => "%8s" % (time > 0 ? self.to_s : ""),
      :crs0 => "%1s" % (time > 0 ? event.course[0] : ""),
      :tim1 => "%-8s" % "",
      :crs1 => "%-1s" % "",
      :tim2 => "%-8s" % "",
      :crs2 => "%-1s" % "",
      :tim3 => "%8s" % (result and result.time ? result : ""),
      :crs3 => "%1s" % (result and result.time ? event.course[0] : ""),
      :hea1 => "%-2s" % "",
      :lan1 => "%-2s" % "",
      :hea2 => "%2s" % (heat ? heat : ""),
      :lan2 => "%2s" % (lane ? lane : ""),
      :plc1 => "%-3s" % "",
      :plc2 => "%3s" % (result and result.place),
      :pnts => "%-4s" % "",
      :strd => "%-2s" % "",
      :flgh => "%-1s" % "",
      :gap1 => "%-15s" % "",
    }
    line = SDIF[line[:mark]][:keys].map { |key| line[key] }.join
    line[-4, 4] = Format.checksum(line)
    line
  end

end

class Relay < ActiveRecord::Base
  belongs_to :invitation
  has_one :club, through: :invitation
  has_many :entries, as: :subject, dependent: :destroy
  has_many :seats, dependent: :destroy
  has_many :dockets, through: :seats

  validates :gender, inclusion: Event::GENDERS

  def age_range
    age_min .. age_max
  end

  def age
    [age_max,18].min
  end

  def name_and_ages
    "#{name}"
  end

  def number
    "xxx"
  end

  def swimmer
    self
  end

  def first_last
    name
  end

  # sorting attribute in the absence of time
  def no_time
    [age, id.hash % 97]  # first by age, then somewhat random
  end

  def permits?(docket)
    seats.count < 4 and (gender == "X" or docket.swimmer.gender == gender) and age_max >= docket.age
  end

  # sdif
  def to_e0
    entry = entries.first # FIXME: there might be more than one
    event = entry.event
    result = entry.results.first  # FIXME: there might be more than one
    stroke_no = {
      "Freestyle" => 1,
      "Backstroke" => 2,
      "Breaststroke" => 3,
      "Butterfly" => 4,
      "Ind Medley" => 5,
    }[entry.stroke]
    letter = name[-1]
    letter = " " if letter != letter.upcase
    line = {
      mark: "E0",
      orgc: "8",
      gap0: "%-8s" % "",
      name: "%1s" % letter,
      team: "  %-4s" % club.symbol[0,4],
      size: "%2d" % 0,
      esex: "%1s" % event.gender,
      dist: "%4d" % event.distance,
      stro: "%d" % stroke_no,
      evnt: "%3d%1s" % [event.pos, "ABCDE"[index]],
      ages: "%4s" % event.cl2_ages,
      agen: "%3s" % "",
      date: "%8s" % event.date.strftime("%m%d%Y"),
      tim0: "%8s" % (entry.time > 0 ? entry.to_s : ""),
      crs0: "%1s" % (entry.time > 0 ? event.course[0] : ""),
      tim1: "%-8s" % "",
      crs1: "%-1s" % "",
      tim2: "%-8s" % "",
      crs2: "%-1s" % "",
      tim3: "%8s" % (result and result.time ? result : ""),
      crs3: "%1s" % (result and result.time and result.time > 0 ? event.course[0] : ""),
      hea1: "%-2s" % "",
      lan1: "%-2s" % "",
      hea2: "%2s" % (entry.heat ? entry.heat : ""),
      lan2: "%2s" % (entry.lane ? entry.lane : ""),
      plc1: "%-3s" % "",
      plc2: "%3s" % (result and result.place),
      pnts: "%-4s" % "",
      strd: "%-2s" % "",
      gap1: ("%-42s" % "") + ("%dN   01  X       " % (result.place % 10)),
    }
    line = SDIF[line[:mark]][:keys].map { |key| line[key] }.join
    line[-4, 4] = Format.checksum(line)
    line
  end
end

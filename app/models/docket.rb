class Docket < ActiveRecord::Base
  belongs_to :swimmer
  belongs_to :invitation
  has_one :competition, :through => :invitation
  has_many :entries, :as => :subject, :dependent => :destroy
  has_many :events, :through => :entries
  has_many :results, through: :entries
  has_many :seats, :dependent => :destroy
  has_many :relays, :through => :seats

  validates :invitation_id, :swimmer_id, :presence => true
  
  delegate :gender, :name, :first_last, :number, :to => :swimmer
  delegate :date, :to => :competition
  delegate :club, :to => :invitation

  before_create :assign_age, unless: :age
  
  def age_range
    age .. age
  end

  def name_and_ages
    "#{swimmer.first_last}, #{age}"
  end

  def personal_best
    entries.map(&:personal_best).sum
  end

  # sorting attribute in the absence of time
  def no_time
    swimmer.age_in_days
  end

  # sdif
  def to_d0 # to be used in case swimmer is registered but not entered
    line = {
      :mark => "D0",
      :orgc => "8",
      :gap0 => "%-8s" % "",
      :name => "%-28s" % swimmer.last_first.encode("ISO-8859-1"),
      :siid => "%-12s" % swimmer.number,
      :atch => "A",
      :citz => "%-3s" % "",
      :dofb => "%8s" % swimmer.birthday.strftime("%m%d%Y"),
      :agen => "%2d" % age,
      :ssex => "%1s" % gender,
      :esex => "%-1s" % "",
      :dist => "%-4s" % "",
      :stro => "%-1s" % "",
      :evnt => "%-4s" % "",
      :ages => "%-4s" % "",
      :date => "%-8s" % "",
      :tim0 => "%-8s" % "",
      :crs0 => "%-1s" % "",
      :tim1 => "%-8s" % "",
      :crs1 => "%-1s" % "",
      :tim2 => "%-8s" % "",
      :crs2 => "%-1s" % "",
      :tim3 => "%-8s" % "",
      :crs3 => "%-1s" % "",
      :hea1 => "%-2s" % "",
      :lan1 => "%-2s" % "",
      :hea2 => "%-2s" % "",
      :lan2 => "%-2s" % "",
      :plc1 => "%-3s" % "",
      :plc2 => "%-3s" % "",
      :pnts => "%-4s" % "",
      :strd => "%-2s" % "",
      :flgh => "%-1s" % "",
      :gap1 => ("   0 ") + ("%-10s" % ""),
    }
    line = SDIF[line[:mark]][:keys].map { |key| line[key] }.join
    line[-4, 4] = Format.checksum(line)
    line
  end

  def to_d3
    line = {
      :mark => "D3",
      :siid => "%-14s" % swimmer.number,
      :frst => "%15s" % "",
      :ethn => "%2s" % "",
      :junr => " ",
      :senr => " ",
      :ymca => " ",
      :coll => " ",
      :summ => " ",
      :mstr => " ",
      :dabl => " ",
      :polo => " ",
      :none => " ",
      :gap0 => "%118s" % "",
    }
    line = SDIF[line[:mark]][:keys].map { |key| line[key] }.join
    line[-4, 4] = Format.checksum(line)
    line
  end

  private
  
  def assign_age
    self.age = swimmer.age(invitation.competition.date)
  end

end

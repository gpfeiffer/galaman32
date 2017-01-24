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

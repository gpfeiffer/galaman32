class Swimmer < ActiveRecord::Base
  default_scope :order => [:last, :first]

  belongs_to :club
  has_many :registrations, :dependent => :destroy
  has_many :competitions, :through => :registrations
  has_many :entries, :through => :registrations
  has_many :aims, :dependent => :destroy
  has_many :qualifications, :through => :aims
  has_many :supports, :dependent => :destroy
  has_many :users, :through => :supports

  GENDERS = ["f", "m"]

  validates :first, :last, :birthday, :gender, :club_id, :presence => true
  validates :gender, :inclusion => GENDERS

  def name
    "#{last}, #{first}"
  end

  def first_last
    "#{first} #{last}"
  end

  def age(date = DateTime.now)
    return 0 unless birthday
    age = date.year - birthday.year
    return age unless birthday + age.years > date
    return age - 1
  end

  def results
    entries.map { |entry| entry.result }.compact
  end

  def personal_best(discipline)
    best = nil
    results.select { |x| x.discipline == discipline }.each do |result|
      if result.time > 0 and (best == nil or best.time > result.time)
        best = result
      end
    end
    return best
  end

  def age_in_days
    (DateTime.now - birthday).to_i
  end

  # mark today in the graph
  def today_marker
    x = (DateTime.now - (birthday + 8.years)).to_i
    return [[x, 0], [x, 12000]]
  end
end

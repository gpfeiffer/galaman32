class Swimmer < ActiveRecord::Base
  default_scope :order => [:last, :first]

  belongs_to :club
  has_many :registrations, :dependent => :destroy
  has_many :competitions, :through => :registrations
  has_many :entries, :through => :registrations
  has_many :aims, :dependent => :destroy
  has_many :qualifications, :through => :aims
  has_many :supports, :dependent => :destroy
  has_many :supporters, :through => :supports, :source => :user
  belongs_to :user

  GENDERS = ["f", "m"]

  validates :first, :last, :birthday, :gender, :club_id, :presence => true
  validates :gender, :inclusion => GENDERS

  def name
    "#{last}, #{first}"
  end

  def first_last
    "#{first} #{last}"
  end

  def email
    user.email
  end

  def age(date = DateTime.now)
    return 0 unless birthday
    age = date.year - birthday.year
    return age unless birthday + age.years > date
    return age - 1
  end

  def results
    entries.map(&:result).compact
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

  # compute swimmer's age in days
  def age_in_days(date = DateTime.now)
    (date - birthday).to_i
  end

  # conversely, compute n-th birthday
  def date_of_age(age)
    return birthday + age.years
  end

  # mark today in the graph
  def today_marker(dist = 100)
    x = (DateTime.now - (birthday + 8.years)).to_i
    return [[x, 0], [x, 120 * dist]]
  end
end

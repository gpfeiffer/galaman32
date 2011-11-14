class Swimmer < ActiveRecord::Base
  default_scope :order => [:last, :first]

  belongs_to :club
  has_many :registrations
  has_many :competitions, :through => :registrations
  has_many :entries, :through => :registrations

  GENDERS = ["f", "m"]

  validates :first, :last, :birthday, :gender, :registration, :presence => true
  validates :gender, :inclusion => GENDERS

  def name
    "#{self.last}, #{self.first}"
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
      if not best or best.time == 0 or result.time < best.time
        best = result
      end
    end
    return best
  end
end
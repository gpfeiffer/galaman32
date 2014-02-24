class Swimmer < ActiveRecord::Base
  default_scope :order => [:last, :first]

  belongs_to :club
  has_many :dockets, :dependent => :destroy
  has_many :competitions, :through => :dockets
  has_many :entries, :through => :dockets
  has_many :aims, :dependent => :destroy
  has_many :qualifications, :through => :aims
  has_many :supports, :dependent => :destroy
  has_many :supporters, :through => :supports, :source => :user
  belongs_to :user

  GENDERS = ["f", "m"]

  validates :first, :last, :birthday, :gender, :club_id, :presence => true
  validates :gender, :inclusion => GENDERS
  validates :number, :uniqueness => true, :allow_blank => true

  def last_first
    "#{last}, #{first}"
  end

  def first_last
    "#{first} #{last}"
  end

  def name
    last_first
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
      if result.time and result.time > 0 and (best == nil or best.time > result.time)
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

  # when did we get our A time?
  def sticking_achievement(qualification, discipline)
    # loop over my results in discipline
    qts = qualification.qualification_times.group_by(&:discipline)[discipline]
    results_by_discipline = results.group_by(&:discipline)[discipline]
    if results_by_discipline
      results_by_discipline.each do |result|
        swimmer_age = age(result.date)
        qt = qts.select { |x| x.age_range.include? swimmer_age }.first
        if qt and result.time and result.time > 0 and result.time < qt.time
          return result
        end
      end
    end
    return nil
  end

  def a_times
    times = Hash[Discipline::STROKES.map { |stroke|  [stroke, []] }]
    q = Qualification.find_by_name("A")
    q.disciplines.uniq.select { |x| x.gender == gender }.each do |discipline|
      a_time = sticking_achievement(q, discipline)
      times[discipline.stroke] << a_time if a_time
    end
    times.each_key do |stroke|
      times[stroke] = times[stroke].sort_by(&:date).first
    end
    return times
  end
end

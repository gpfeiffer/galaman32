class Qualification < ActiveRecord::Base
  has_many :qualification_times
  has_many :disciplines, :through => :qualification_times
  has_many :standards
  has_many :competitions, :through => :standards

  def age_groups
    qualification_times.each.map { |x| [x.age_min, x.age_max] }.sort.uniq
  end

  def filter_disciplines(gender, course)
    disciplines.uniq.find_all { |x| x.gender == gender and x.course == course }
  end

  def filter_time(discipline, age_group)
    qualification_times.select{ |x| x.discipline == discipline and [x.age_min, x.age_max] == age_group }.first
  end

  def courses
    qualification_times.each.map { |x| x.course }.sort.uniq
  end

  def genders
    qualification_times.each.map { |x| x.gender }.sort.uniq
  end
end

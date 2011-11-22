class Qualification < ActiveRecord::Base
  has_many :qualification_times
  has_many :disciplines, :through => :qualification_times
  has_many :standards
  has_many :competitions, :through => :standards

  validates :name, :presence => true

  def age_ranges
    qualification_times.each.map { |x| x.age_range }.sort_by(&:first).uniq
  end

  def filter_disciplines(gender, course)
    disciplines.uniq.find_all { |x| x.gender == gender and x.course == course }
  end

  def filter_time(discipline, ages)
    qualification_times.select{ |x| x.discipline == discipline and x.age_range == ages }.first
  end

  def courses
    qualification_times.each.map { |x| x.course }.sort.uniq
  end

  def genders
    qualification_times.each.map { |x| x.gender }.sort.uniq
  end

  # how to graph a qualification
  def to_graph(swimmer, discipline)
    graph = []
    dob =  swimmer.birthday
    qualification_times.find_all_by_discipline_id(discipline.id).each do |qt|
      graph << [[((dob + qt.age_range.first.years) - (dob + 8.years)).to_i, 0].max, qt.time]
      graph << [[((dob + (qt.age_range.last + 1).years - 1.day) - (dob + 8.years)).to_i, 0].max, qt.time]
    end
    return graph
  end

end

class Qualification < ActiveRecord::Base
  has_many :qualification_times
  has_many :disciplines, :through => :qualification_times
  has_many :standards
  has_many :competitions, :through => :standards
  has_many :aims

  validates :name, :presence => true

  def age_ranges(gender)
    qualification_times.select { |x| x.gender == gender }.map(&:age_range).sort_by(&:first).uniq
  end

  def filter_disciplines(gender, course) 
    disciplines.find_all_by_gender_and_course(gender, course).uniq.sort_by { |x| [Discipline::STROKES.index(x.stroke), x.distance] }
  end

  def filter_time(discipline, ages)
    qualification_times.select { |x| x.discipline == discipline and x.age_range == ages }.first
  end

  def courses
    qualification_times.map(&:course).uniq
  end

  def genders
    qualification_times.map(&:gender).uniq
  end

  # provide a table of times for a given gender and age
  def to_table(gender, age)

    # select applicable qualification times, return nil if none apply.
    times = qualification_times.select { |x| x.gender == gender and x.age_range.include? age }
    if times.blank?
      return
    end

    # compute the address of each stroke in the list of strokes
    strokes = Discipline::STROKES
    col = {}
    strokes.each_with_index { |stroke, index| col[stroke] = index }

    # compute at table title
    title = { 'f' => "Girls", 'm' => "Boys" }[gender]

    # group times by discipline and course, fill into table slots.
    rows = times.group_by { |x| [x.discipline.distance, x.discipline.course] } 
    keys = rows.keys.sort_by { |x| [x[0], -x[1][0].ord] }
    body = []
    keys.each do |key| 
      list = strokes.map { }
      rows[key].each do |qt|
        list[col[qt.discipline.stroke]] = qt
      end
      body << { :label => key[0].to_s + "m " + key[1], :list => list }
    end

    # return table
    { :title => title, :heads => strokes, :body => body }
  end

  # how to graph a qualification
  def to_graph(swimmer, discipline)
    graph = []
    dob =  swimmer.birthday
    qualification_times.find_all_by_discipline_id(discipline.id).each do |qt|
      graph << [[((dob + qt.age_range.first.years) - (dob + 8.years)).to_i, 0].max, qt.time]
      graph << [[((dob + (qt.age_range.last + 1).years - 1.day) - (dob + 8.years)).to_i, 3652 ].min, qt.time]
    end
    return graph.sort_by { |x| x[0] }
  end

end

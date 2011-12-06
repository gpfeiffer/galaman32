class Discipline < ActiveRecord::Base
  has_many :events
  has_many :competitions, :through => :events
  has_many :qualification_times

  # FIXME: make sure no event or qualification_time is refering before delete

  DISTANCES = [50, 100, 200, 400, 800, 1500]
  COURSES = ["SC", "LC"]
  STROKES = [
    "Freestyle", 
    "Backstroke", 
    "Breaststroke", 
    "Butterfly", 
    "Ind Medley"
  ]

  validates :gender, :distance, :course, :stroke, :presence => true
  validates :gender, :inclusion => Swimmer::GENDERS
  validates :distance, :inclusion => DISTANCES
  validates :course, :inclusion => COURSES
  validates :stroke, :inclusion => STROKES

  def name
    sprintf("%s [%s] %dm (%s)", self.stroke, self.gender, self.distance, self.course)
  end

  def to_words
    sprintf("%s %dm %s (%s)",  { 'f' => "Girls", 'm' => "Boys" }[gender], distance, stroke, course)
  end
end

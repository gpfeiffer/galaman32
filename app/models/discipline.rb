class Discipline < ActiveRecord::Base
  has_many :events
  has_many :competitions, :through => :events

  DISTANCES = [50, 100, 200, 400]
  COURSES = ["SC", "LC"]
  STROKES = [
    "Backstroke", 
    "Breaststroke", 
    "Butterfly", 
    "Freestyle", 
    "Ind Medley"
  ]

  def name
    sprintf("%s [%s] %dm (%s)", self.stroke, self.gender, self.distance, self.course)
  end
end

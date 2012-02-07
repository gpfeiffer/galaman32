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
  TYPES = [ "I", "R" ] # Individual or Relay

  validates :gender, :distance, :course, :stroke, :type, :presence => true
  validates :gender, :inclusion => Swimmer::GENDERS
  validates :distance, :inclusion => DISTANCES
  validates :course, :inclusion => COURSES
  validates :stroke, :inclusion => STROKES
  validates :type, :inclusion => TYPES

  def name
    sprintf("%s [%s] %dm (%s)", self.stroke, self.gender, self.distance, self.course)
  end

  def nickname
    dict = {
    "Freestyle" => 'Free', 
    "Backstroke" => 'Back', 
    "Breaststroke" => 'Breast', 
    "Butterfly" => 'Fly', 
    "Ind Medley" => 'IM'
    }
    sprintf("%dm %s", distance, dict[stroke])
  end

  def to_words
    sprintf("%s %dm %s (%s)",  { 'f' => "Girls", 'm' => "Boys" }[gender], distance, stroke, course)
  end
end

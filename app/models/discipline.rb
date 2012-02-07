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
  MODES = [ "I", "R" ] # Individual or Relay

  validates :gender, :distance, :course, :stroke, :mode, :presence => true
  validates :gender, :inclusion => Swimmer::GENDERS
  validates :distance, :inclusion => DISTANCES
  validates :course, :inclusion => COURSES
  validates :stroke, :inclusion => STROKES
  validates :mode, :inclusion => MODES

  def relay?
    mode == "R"
  end

  def name
    sprintf("%s [%s] %s%dm (%s)", stroke, gender, relay? ? "4x" : "", distance, course)
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
    if relay? then
      sprintf("%s 4x%dm %s Relay (%s)",  { 'f' => "Girls", 'm' => "Boys" }[gender], distance, stroke, course)
    else
      sprintf("%s %dm %s (%s)",  { 'f' => "Girls", 'm' => "Boys" }[gender], distance, stroke, course)
    end
  end
end

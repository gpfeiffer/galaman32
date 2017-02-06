class Discipline < ActiveRecord::Base
  has_many :events
  has_many :competitions, :through => :events
  has_many :qualification_times
  has_many :qualifications, :through=> :qualification_times

  # FIXME: make sure no event or qualification_time is refering before delete

  DISTANCES = [25, 50, 100, 200, 400, 800, 1500]
  COURSES = ["SC", "LC"]
  STROKES = [
    "Freestyle", 
    "Backstroke", 
    "Breaststroke", 
    "Butterfly", 
    "Ind Medley"
  ]
  MODES = [ "I", "R" ] # Individual or Relay

  validates :distance, :course, :stroke, :mode, :presence => true
  validates :distance, :inclusion => DISTANCES
  validates :course, :inclusion => COURSES
  validates :stroke, :inclusion => STROKES
  validates :mode, :inclusion => MODES

  def results
    events.map(&:results).sum
  end

  # customize json representation
  def as_json(options = {})
    super(root: false, only: [:id], methods: [:results])
  end

  def is_relay?
    mode == "R"
  end

  def name
    sprintf("%s %s%dm (%s)", stroke, is_relay? ? "4x" : "", distance, course)
  end

  def nickname
    dict = {
    "Freestyle" => 'Free',
    "Backstroke" => 'Back',
    "Breaststroke" => 'Breast',
    "Butterfly" => 'Fly',
    "Ind Medley" => 'IM'
    }
    sprintf("%s%dm %s", is_relay? ? "4x" : "", distance, dict[stroke])
  end

  def to_words
    if is_relay? then
      sprintf("4x%dm %s %s Relay", distance, course, stroke == "Ind Medley" ? "Medley" : stroke)
    else
      sprintf("%dm %s %s", distance, course, stroke)
    end
  end

  def distance_stroke
    if is_relay? then
      sprintf("4x%dm %s Relay", distance, stroke == "Ind Medley" ? "Medley" : stroke)
    else
      sprintf("%dm %s", distance, stroke)
    end
  end

  def distance_course_stroke
    if is_relay? then
      sprintf("4x%dm %s %s Relay", distance, course, stroke == "Ind Medley" ? "Medley" : stroke)
    else
      sprintf("%dm %s %s", distance, course, stroke)
    end
  end

  def distance_in_words
    ((is_relay? ? "4x" : "") + "%dm") % distance
  end

  def stroke_in_words
    ("%s" + (is_relay? ? " Relay" : "")) % ((is_relay? and stroke == "Ind Medley") ? "Medley" : stroke)
  end

  def to_s
    to_words
  end

  def to_hash
    keys = %w(distance course stroke mode)
    attributes.select { |k, v| keys.include? k }
  end

  def opposite
    hash = to_hash
    hash['course'] = { 'SC' => 'LC', 'LC' => 'SC' }[hash['course']]
    Discipline.where(hash).first
  end
end

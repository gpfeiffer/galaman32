module EventsHelper
  MAX_NO_EVENTS = 50

  def available_poss(competition, event)
    (1..MAX_NO_EVENTS).to_a - (competition.events.map { |x| x.pos } - [event.pos])
  end

  def gender_word(gender)
    {
      'F' => "Girls",
      'M' => "Boys",
      'X' => "Mixed",
    }[gender]
  end
end

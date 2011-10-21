module EventsHelper
  MAX_NO_EVENTS = 50

  def available_poss(competition)
    (1..MAX_NO_EVENTS).to_a - competition.events.map{ |x| x.pos }
  end
end

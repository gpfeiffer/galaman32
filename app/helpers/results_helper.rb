module ResultsHelper
  def best_result(results)
    best = nil
    results.each do |result|
      if not best or best.time == 0 or result.time < best.time
        best = result
      end
    end
    return best
  end

  # how to graph a list of results (of the same swimmer)
  def graph_results(results)
    swimmer = results.first.entry.swimmer
    graph = []
    results.each do |result|
      graph << [(result.entry.event.competition.date - (swimmer.birthday+8.years)).to_i, result.time]
    end
    return graph
  end
end

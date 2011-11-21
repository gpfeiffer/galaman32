module ResultsHelper
  def best_result(results)
    best = nil
    results.each do |result|
      if result.time > 0 and (best == nil or best.time > result.time)
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

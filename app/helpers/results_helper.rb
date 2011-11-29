module ResultsHelper
  def ordinal_number(obj)
    obj.blank? ? "" : "#{obj}."     
  end

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
      if result.time > 0
        graph << [(result.entry.event.competition.date - (swimmer.birthday+8.years)).to_i, result.time]
      end
    end
    # HACK: a single point doesn't seem to get an x-value
    if graph.count == 1
      graph << [graph[0][0]+1, graph[0][1]]
    end
    return graph.sort_by { |x| x[0] }
  end
end

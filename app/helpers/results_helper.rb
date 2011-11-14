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
end

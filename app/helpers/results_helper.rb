module ResultsHelper
  def stage_word(stage)
    { 
      "P" => "Prelims",
      "S" => "Semis",
      "F" => "Finals",
    }[stage]
  end

  def ordinal_number(obj)
    obj.blank? ? "" : "#{obj}."     
  end

  def best_result(results)
    result = results.min
    return result if result.time and result.time > 0
  end
end

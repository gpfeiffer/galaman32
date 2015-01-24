def set_differential(stroke, diff)
  disciplines = Discipline.where(stroke: stroke, mode: 'I').group_by(&:course)
  { "SC" => 1, "LC" => -1 }.each do |course, sign|
    disciplines[course].each do |discipline|
      discipline.differential = discipline.distance * sign * diff / 100
      discipline.save
    end
  end
end

{
  'Butterfly' =>    140,
  'Backstroke' =>   120,
  'Breaststroke' => 200,
  'Freestyle' =>    160, 
  'Ind Medley' =>   160,
}.each { |stroke, diff| set_differential(stroke, diff) }

pdf.text @competition.name, :size => 18, :style => :bold
pdf.text "#{@competition.location}, #{@competition.date}", :size => 14

pdf.move_down 20

rows = @registrations.sort_by { |x| x.swimmer.name }.each.map do |reg|
  [
    reg.swimmer.name,
    reg.swimmer.age(@competition.date).to_s,
    reg.entries.select { |x| x.discipline.stroke == "Breaststroke" }.first.result.to_s,
    reg.entries.select { |x| x.discipline.stroke == "Breaststroke" }.first.result.merit,
    reg.entries.select { |x| x.discipline.stroke == "Freestyle" }.first.result.to_s,
    reg.entries.select { |x| x.discipline.stroke == "Freestyle" }.first.result.merit
  ]
end

header = ["Swimmer", "Age", "100 Breast", "",  "100 Free", ""]

pdf.font("Helvetica", :size => 12) do
pdf.table [header] + rows, 
  :row_colors => ["DDFFFF", "FFDDFF"],
  :cell_style => { :borders => [], :padding => [3, 6, 3, 6], :align => :right },
  :header => true
end

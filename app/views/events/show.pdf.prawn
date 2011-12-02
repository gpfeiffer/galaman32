pdf.text "Event #{@event.id}. #{@event.discipline.name}", :size => 16, :style => :bold

entries = @event.seeded_entries.map do |entry|
  [
    entry.swimmer.name,
    entry.swimmer.age(@event.competition.date),
    entry.swimmer.club.symbol,
    entry.to_s,
    '_' * 8
  ]
end

header = ["Swimmer", "Age", "Team", "Seed Time", "Result"]

pdf.font("Times-Roman", :size => 8) do
pdf.table [header] + entries, 
  :row_colors => ["FFFFFF", "EEEEEE"],
  :cell_style => { :borders => [], :padding => [1, 6, 1, 6] },
  :header => true
end

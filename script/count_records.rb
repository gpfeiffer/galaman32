count = {}
[
Aim,
Assignment,
Club,
Competition,
Discipline,
Docket,
Entry,
Event,
Invitation,
QualificationTime,
Qualification,
Relay,
Result,
Role,
Seat,
Standard,
Support,
Swimmer,
User,
].each do |table|
  count[table.name] = table.count
end
count.each do |k, v|
  puts "#{k}: #{v}"
end
puts
puts "total: %s" % count.values.sum

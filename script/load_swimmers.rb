Swimmer.transaction do
  (1..5).each do |i|
    (9..15).each do |a|
      Swimmer.create(:first => "A", :last => "Name#{a}",
        :club_id => "#{i}", :birthday => "01/10/#{2011-a}",
        :gender => "f", :registration => "00001234")
    end
  end
end
Swimmer.transaction do
  (1..5).each do |i|
    (9..15).each do |a|
      Swimmer.create(:first => "B", :last => "Name#{a}",
        :club_id => "#{i}", :birthday => "03/09/#{2011-a}",
        :gender => "m", :registration => "00001234")
    end
  end
end

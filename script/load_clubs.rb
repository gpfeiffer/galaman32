Club.transaction do
  (1..5).each do |i|
    Club.create(:full_name => "Club #{i}", :symbol => "C#{i}",
      :contact => "empty", :email => "club-#{i}@example.com")
  end
end

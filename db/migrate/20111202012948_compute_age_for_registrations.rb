class ComputeAgeForRegistrations < ActiveRecord::Migration
  def self.up
    Registration.all.each do |registration|
      registration.update_attribute(:age, registration.swimmer.age(registration.competition.date))
    end
  end

  def self.down
    Registration.all.each do |registration|
      registration.update_attribute(:age, nil)
    end
  end
end

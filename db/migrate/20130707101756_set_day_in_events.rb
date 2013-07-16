class SetDayInEvents < ActiveRecord::Migration
  def self.up
    Event.all.each do |event|
      event.update_attribute(:day, (event.date - event.competition.date).to_i + 1)
    end
  end

  def self.down
    Event.all.each do |event|
      event.update_attribute(:day, nil)
    end
  end
end

class SetDateInEvents < ActiveRecord::Migration
  def self.up
    Event.all.each do |event|
      event.update_attribute(:date, event.competition.date)
    end
  end

  def self.down
    Event.all.each do |event|
      event.update_attribute(:date, nil)
    end
  end
end

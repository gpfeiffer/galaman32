class FindRegistrationIdsForEntries < ActiveRecord::Migration
  def self.up
    Entry.all.each do |entry|
      entry.update_attribute(:registration, entry.event.competition.registrations.where(:swimmer_id => entry.swimmer).first)
    end
  end

  def self.down
    Entry.all.each do |entry|
      entry.update_attribute(:swimmer, entry.registration.swimmer)
    end
  end
end

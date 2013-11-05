class SetSubjectInEntry < ActiveRecord::Migration
  def self.up
    Entry.all.each do |entry|
      entry.subject = entry.relay ? entry.relay : entry.registration
      entry.save
    end
  end

  def self.down
    Entry.all.each do |entry|
      if entry.subject.class == Relay
        entry.relay = entry.subject
      elsif entry.subject.class == Registration
        entry.registration = entry.subject
      end
      entry.save
    end
  end
end

class AddEventIdToHeats < ActiveRecord::Migration
  def self.up
    add_column :heats, :event_id, :integer
  end

  def self.down
    remove_column :heats, :event_id
  end
end

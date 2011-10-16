class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.integer :event_id
      t.integer :swimmer_id
      t.integer :seed_time
      t.integer :race_time

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end

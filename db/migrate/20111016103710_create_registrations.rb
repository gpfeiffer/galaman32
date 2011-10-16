class CreateRegistrations < ActiveRecord::Migration
  def self.up
    create_table :registrations do |t|
      t.integer :competition_id
      t.integer :swimmer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :registrations
  end
end

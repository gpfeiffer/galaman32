class CreateSeats < ActiveRecord::Migration
  def self.up
    create_table :seats do |t|
      t.integer :relay_id
      t.integer :swimmer_id
      t.integer :pos

      t.timestamps
    end
  end

  def self.down
    drop_table :seats
  end
end

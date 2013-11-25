class DropHeats < ActiveRecord::Migration
  def self.up
    drop_table :heats
  end

  def self.down
    create_table :heats do |t|
      t.integer :pos

      t.timestamps
    end
  end
end

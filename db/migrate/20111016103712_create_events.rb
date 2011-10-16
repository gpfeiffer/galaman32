class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :competition_id
      t.integer :discipline_id
      t.integer :pos
      t.integer :age_min
      t.integer :age_max

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end

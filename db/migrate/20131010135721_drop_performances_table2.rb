class DropPerformancesTable2 < ActiveRecord::Migration
  def self.up
    drop_table :performances
  end

  def self.down
    create_table :performances do |t|
      t.integer :user_id
      t.integer :time
      t.integer :discipline_id
      t.string :name
      t.string :competition
      t.date :date

      t.timestamps
    end
  end
end

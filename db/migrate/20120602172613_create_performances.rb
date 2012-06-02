class CreatePerformances < ActiveRecord::Migration
  def self.up
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

  def self.down
    drop_table :performances
  end
end

class CreateQualificationTimes < ActiveRecord::Migration
  def self.up
    create_table :qualification_times do |t|
      t.integer :qualification_id
      t.integer :discipline_id
      t.string :gender
      t.integer :age_min
      t.integer :age_max
      t.integer :time

      t.timestamps
    end
  end

  def self.down
    drop_table :qualification_times
  end
end

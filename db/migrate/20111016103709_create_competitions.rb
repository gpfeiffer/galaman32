class CreateCompetitions < ActiveRecord::Migration
  def self.up
    create_table :competitions do |t|
      t.string :name
      t.string :location
      t.date :date

      t.timestamps
    end
  end

  def self.down
    drop_table :competitions
  end
end

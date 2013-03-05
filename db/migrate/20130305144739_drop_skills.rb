class DropSkills < ActiveRecord::Migration
  def self.up
    drop_table :skills
  end

  def self.down
    create_table :skills do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end

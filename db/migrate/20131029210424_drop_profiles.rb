class DropProfiles < ActiveRecord::Migration
  def self.up
    drop_table :profiles
  end

  def self.down
    create_table :profiles do |t|
      t.integer :user_id
      t.integer :club_id
      t.integer :swimmer_id

      t.timestamps
    end
  end
end

class CreateRelays < ActiveRecord::Migration
  def self.up
    create_table :relays do |t|
      t.string :name
      t.integer :age_min
      t.integer :age_max
      t.integer :invitation_id

      t.timestamps
    end
  end

  def self.down
    drop_table :relays
  end
end

class CreateClubs < ActiveRecord::Migration
  def self.up
    create_table :clubs do |t|
      t.string :full_name
      t.string :symbol
      t.text :contact
      t.text :email

      t.timestamps
    end
  end

  def self.down
    drop_table :clubs
  end
end

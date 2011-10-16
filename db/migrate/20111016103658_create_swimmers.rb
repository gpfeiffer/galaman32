class CreateSwimmers < ActiveRecord::Migration
  def self.up
    create_table :swimmers do |t|
      t.string :first
      t.string :last
      t.integer :club_id
      t.date :birthday
      t.string :gender
      t.string :registration

      t.timestamps
    end
  end

  def self.down
    drop_table :swimmers
  end
end

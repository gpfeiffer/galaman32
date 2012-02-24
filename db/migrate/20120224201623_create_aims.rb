class CreateAims < ActiveRecord::Migration
  def self.up
    create_table :aims do |t|
      t.integer :swimmer_id
      t.integer :qualification_id
      t.date :date

      t.timestamps
    end
  end

  def self.down
    drop_table :aims
  end
end

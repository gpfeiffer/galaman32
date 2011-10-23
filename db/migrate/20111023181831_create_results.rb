class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.integer :entry_id
      t.integer :time

      t.timestamps
    end
  end

  def self.down
    drop_table :results
  end
end

class AddLaneToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :lane, :integer
  end

  def self.down
    remove_column :entries, :lane
  end
end

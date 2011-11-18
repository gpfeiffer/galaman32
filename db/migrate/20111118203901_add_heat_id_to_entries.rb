class AddHeatIdToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :heat_id, :integer
  end

  def self.down
    remove_column :entries, :heat_id
  end
end

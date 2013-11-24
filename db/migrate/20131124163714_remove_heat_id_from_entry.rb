class RemoveHeatIdFromEntry < ActiveRecord::Migration
  def self.up
    remove_column :entries, :heat_id
  end

  def self.down
    add_column :entries, :heat_id, :integer
  end
end

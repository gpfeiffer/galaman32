class AddRelayIdToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :relay_id, :integer
  end

  def self.down
    remove_column :entries, :relay_id
  end
end

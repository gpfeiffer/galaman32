class RemoveSwimmerIdFromEntries < ActiveRecord::Migration
  def self.up
    remove_column :entries, :swimmer_id
  end

  def self.down
    add_column :entries, :swimmer_id, :integer
  end
end

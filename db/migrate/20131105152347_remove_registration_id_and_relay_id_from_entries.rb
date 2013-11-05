class RemoveRegistrationIdAndRelayIdFromEntries < ActiveRecord::Migration
  def self.up
    remove_column :entries, :registration_id
    remove_column :entries, :relay_id
  end

  def self.down
    add_column :entries, :relay_id, :integer
    add_column :entries, :registration_id, :integer
  end
end

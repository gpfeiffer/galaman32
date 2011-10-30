class AddRegistrationIdToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :registration_id, :integer
  end

  def self.down
    remove_column :entries, :registration_id
  end
end

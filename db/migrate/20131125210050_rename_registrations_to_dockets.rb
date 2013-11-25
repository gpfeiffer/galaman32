class RenameRegistrationsToDockets < ActiveRecord::Migration
  def self.up
    rename_table :registrations, :dockets
    rename_column :seats, :registration_id, :docket_id
  end

  def self.down
    rename_table :dockets, :registrations
    rename_column :seats, :docket_id, :registration_id
  end
end

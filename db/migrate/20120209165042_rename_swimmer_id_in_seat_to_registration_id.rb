class RenameSwimmerIdInSeatToRegistrationId < ActiveRecord::Migration
  def self.up
    rename_column :seats, :swimmer_id, :registration_id
  end

  def self.down
    rename_column :seats, :registration_id, :swimmer_id
  end
end

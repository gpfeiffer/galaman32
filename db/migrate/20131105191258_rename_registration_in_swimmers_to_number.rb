class RenameRegistrationInSwimmersToNumber < ActiveRecord::Migration
  def self.up
    rename_column :swimmers, :registration, :number
  end

  def self.down
    rename_column :swimmers, :number, :registration
  end
end

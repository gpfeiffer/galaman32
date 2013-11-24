class RenameTempInEntriesToHeat < ActiveRecord::Migration
  def self.up
    rename_column :entries, :temp, :heat
  end

  def self.down
    rename_column :entries, :heat, :temp
  end
end

class RenameSeedTimeInEntryToTime < ActiveRecord::Migration
  def self.up
    rename_column :entries, :seed_time, :time
  end

  def self.down
    rename_column :entries, :time, :seed_time
  end
end

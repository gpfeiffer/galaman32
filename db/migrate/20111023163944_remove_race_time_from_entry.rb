class RemoveRaceTimeFromEntry < ActiveRecord::Migration
  def self.up
    remove_column :entries, :race_time
  end

  def self.down
    add_column :entries, :race_time, :integer
  end
end

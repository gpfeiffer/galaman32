class AddTempToEntry < ActiveRecord::Migration
  def self.up
    add_column :entries, :temp, :integer
  end

  def self.down
    remove_column :entries, :temp
  end
end

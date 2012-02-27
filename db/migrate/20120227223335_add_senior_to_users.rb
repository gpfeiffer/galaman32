class AddSeniorToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :senior, :boolean, :default => false
  end

  def self.down
    remove_column :users, :senior
  end
end

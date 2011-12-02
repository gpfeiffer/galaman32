class AddAgeToRegistrations < ActiveRecord::Migration
  def self.up
    add_column :registrations, :age, :integer
  end

  def self.down
    remove_column :registrations, :age
  end
end

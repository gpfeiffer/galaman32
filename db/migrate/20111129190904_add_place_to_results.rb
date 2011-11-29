class AddPlaceToResults < ActiveRecord::Migration
  def self.up
    add_column :results, :place, :integer
  end

  def self.down
    remove_column :results, :place
  end
end

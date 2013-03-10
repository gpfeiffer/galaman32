class AddProfileIdToRatings < ActiveRecord::Migration
  def self.up
    add_column :ratings, :profile_id, :integer
  end

  def self.down
    remove_column :ratings, :profile_id
  end
end

class AddClubIdToRegistration < ActiveRecord::Migration
  def self.up
    add_column :registrations, :club_id, :integer
  end

  def self.down
    remove_column :registrations, :club_id
  end
end

class RemoveClubIdFromRegistration < ActiveRecord::Migration
  def self.up
    remove_column :registrations, :club_id
  end

  def self.down
    add_column :registrations, :club_id, :integer
  end
end

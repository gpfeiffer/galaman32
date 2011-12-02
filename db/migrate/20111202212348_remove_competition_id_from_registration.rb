class RemoveCompetitionIdFromRegistration < ActiveRecord::Migration
  def self.up
    remove_column :registrations, :competition_id
  end

  def self.down
    add_column :registrations, :competition_id, :integer
  end
end

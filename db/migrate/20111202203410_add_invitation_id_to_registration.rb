class AddInvitationIdToRegistration < ActiveRecord::Migration
  def self.up
    add_column :registrations, :invitation_id, :integer
  end

  def self.down
    remove_column :registrations, :invitation_id
  end
end

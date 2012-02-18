class FindClubIdForRegistration < ActiveRecord::Migration
  def self.up
    Registration.all.each do |registration|
      club = registration.swimmer.club
      registration.update_attribute(:club_id, club.id)
    end
  end

  def self.down
  end
end

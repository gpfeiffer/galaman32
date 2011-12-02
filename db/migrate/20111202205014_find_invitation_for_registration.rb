class FindInvitationForRegistration < ActiveRecord::Migration
  def self.up
    Registration.all.each do |registration|
      club = registration.swimmer.club
      competition = registration.competition
      invitation = Invitation.find_by_club_id_and_competition_id(club, competition) || Invitation.new(:club => club, :competition => competition)
      registration.update_attribute(:invitation, invitation)
    end
  end

  def self.down
    Registration.all.each do |registration|
      registration.update_attribute(:competition, registration.invitation.competition) 
    end
  end
end

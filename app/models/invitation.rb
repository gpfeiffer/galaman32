class Invitation < ActiveRecord::Base
  belongs_to :club
  belongs_to :competition
end

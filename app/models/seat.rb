class Seat < ActiveRecord::Base
  belongs_to :relay
  belongs_to :registration
end

class Registration < ActiveRecord::Base
  belongs_to :swimmer
  belongs_to :competition
end

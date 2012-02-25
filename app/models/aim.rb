class Aim < ActiveRecord::Base
  belongs_to :swimmer
  belongs_to :qualification
end

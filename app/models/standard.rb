class Standard < ActiveRecord::Base
  belongs_to :competition
  belongs_to :qualification
end

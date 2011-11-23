class Standard < ActiveRecord::Base
  belongs_to :competition
  belongs_to :qualification

  validates :competition_id, :qualification_id, :presence => true
end

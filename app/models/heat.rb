class Heat < ActiveRecord::Base
  belongs_to :event
  has_many :entries

  validates :event_id, :presence => true
end

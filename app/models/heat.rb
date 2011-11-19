class Heat < ActiveRecord::Base
  belongs_to :event
  has_many :entries
end

class Split < ActiveRecord::Base
  attr_accessible :length, :result_id, :time

  attr_accessor :lap

  belongs_to :result

  default_scope order: :length
end

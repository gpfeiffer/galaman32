class Relay < ActiveRecord::Base
  belongs_to :invitation

  def age_range
    age_min .. age_max
  end
end

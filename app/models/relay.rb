class Relay < ActiveRecord::Base
  belongs_to :invitation
  has_one :club, :through =>:invitation
  has_many :entries, :dependent => :destroy

  def age_range
    age_min .. age_max
  end
end

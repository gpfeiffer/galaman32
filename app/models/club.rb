class Club < ActiveRecord::Base
  has_many :swimmers

  def name
    "#{self.full_name} (#{self.symbol})"
  end
end

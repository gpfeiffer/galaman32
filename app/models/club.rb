class Club < ActiveRecord::Base
  has_many :swimmers

  validates :full_name, :symbol, :presence => true

  def name
    "#{self.full_name} (#{self.symbol})"
  end
end

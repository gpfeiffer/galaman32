class Club < ActiveRecord::Base
  has_many :swimmers
  has_many :invitations
  has_many :competitions, :through => :invitations

  validates :full_name, :symbol, :presence => true

  def name
    "#{self.full_name} (#{self.symbol})"
  end
end

class Club < ActiveRecord::Base
  has_many :swimmers, :dependent => :destroy
  has_many :invitations, :dependent => :destroy
  has_many :competitions, :through => :invitations
  has_many :registrations

  validates :full_name, :symbol, :presence => true

  def name
    "#{self.full_name} (#{self.symbol})"
  end
end

class Club < ActiveRecord::Base
  default_scope :order => :full_name

  has_many :swimmers, :dependent => :destroy
  has_many :invitations, :dependent => :destroy
  has_many :competitions, :through => :invitations
  has_many :registrations, :through => :invitations

  validates :full_name, :symbol, :presence => true

  def name
    "#{self.full_name} (#{self.symbol})"
  end

  def to_s
    full_name
  end

  def entries
    registrations.map(&:entries).sum
  end

end

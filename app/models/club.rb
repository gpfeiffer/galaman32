class Club < ActiveRecord::Base
  default_scope order: :full_name

  has_many :swimmers, dependent: :destroy
  has_many :invitations, dependent: :destroy
    has_many :competitions, through: :invitations
    has_many :dockets, through: :invitations
      has_many :entries, through: :dockets
        has_many :results, through: :entries

  validates :full_name, :symbol, presence: true
  validates :symbol, uniqueness: true

  def name
    "#{full_name} (#{symbol})"
  end

  def to_s
    full_name
  end

end

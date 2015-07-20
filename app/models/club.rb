class Club < ActiveRecord::Base
  default_scope order: :full_name

  has_many :swimmers, dependent: :destroy
  has_many :invitations, dependent: :destroy
    has_many :competitions, through: :invitations
    has_many :dockets, through: :invitations
      has_many :entries, through: :dockets
        has_many :results, through: :entries

  validates :full_name, :code, presence: true
  validates :code, uniqueness: true

  def symbol
    lsc.present? ? "#{code}-#{lsc}" : code
  end

  def name
    "#{full_name} (#{symbol})"
  end

  def to_s
    full_name
  end

end

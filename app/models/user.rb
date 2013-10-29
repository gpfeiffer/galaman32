class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name

  has_many :assignments, :dependent => :destroy
  has_many :roles, :through => :assignments
  has_many :supports, :dependent => :destroy
  has_many :beneficiaries, :through => :supports, :source => :swimmer
  has_one :swimmer

  default_scope :order => :email

  def role? symbol
    roles.map(&:name).include? symbol.to_s.camelcase
  end
  
  def admin?
    role? :admin
  end

  def to_s
    name.present? ? name : email.split("@")[0]
  end
end

class User < ActiveRecord::Base
  enum role: [:user, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable

  mattr_accessor :name_length
  @@name_length = (0..254)

  mattr_accessor :email_length
  @@email_length = (0..254)

  mattr_accessor :password_length
  @@password_length = (8..128)

  validates :name, presence: true
  validates :name, length: { in: name_length }, allow_blank: true
  validates :email, presence: true
  validates :email, length: { in: email_length }, allow_blank: true
  validates :email, format: { with: /\A[a-zA-Z0-9_\.+\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-\.]+\z/ }, allow_blank: true
  validates :password, presence: true, if: 'encrypted_password.blank?'
  validates :password, length: { in: password_length }, allow_blank: true
  validates :password, confirmation: true, allow_blank: true
end

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

  MAX_FIELD_LENGTH = 254

  def self.max_name_length
    MAX_FIELD_LENGTH
  end

  def self.max_email_length
    MAX_FIELD_LENGTH
  end

  MIN_PASSWORD_LENGTH = 8
  MAX_PASSWORD_LENGTH = 128

  def self.min_password_length
    MIN_PASSWORD_LENGTH
  end

  def self.max_password_length
    MAX_PASSWORD_LENGTH
  end

  validates :name, presence: true, length: { maximum: max_name_length }
  validates :email, presence: true, length: { maximum: max_email_length },
    format: { with: /\A[a-zA-Z0-9_\.+\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-\.]+\z/ }
  validates :password, presence: true, on: :create
  validates :password, length: { minimum: min_password_length, maximum: max_password_length }, confirmation: true

end

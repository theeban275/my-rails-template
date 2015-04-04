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

  validates :name, presence: true
  validates :name, length: { maximum: max_name_length }, allow_blank: true
  validates :email, presence: true
  validates :email, length: { maximum: max_email_length }, allow_blank: true
  validates :email, format: { with: /\A[a-zA-Z0-9_\.+\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-\.]+\z/ }, allow_blank: true
  validates :password, presence: true, if: 'encrypted_password.blank?'
  validates :password, length: { minimum: min_password_length, maximum: max_password_length }, allow_blank: true
  validates :password, confirmation: true, allow_blank: true
end

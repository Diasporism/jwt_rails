class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, email: true
  validates :password, length: { minimum: 8 }, allow_nil: true

  has_secure_password
end

class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  has_secure_password
end

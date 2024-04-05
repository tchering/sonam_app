class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name, presence: true
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    length: { maximum: 50 },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, length: { minimum: 5, maximum: 50 }, format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+\z/, message: "must include at least one uppercase letter, one lowercase letter, and one number" }
end

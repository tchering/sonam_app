class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_create :create_activation_digest

  # before_save { self.email = email.downcase }
  before_save :downcase_email # We have defined method below in private section
  validates :name, presence: true
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    length: { maximum: 50 },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, length: { minimum: 5, maximum: 50 }, allow_nil: true, format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+\z/, message: "must include at least one uppercase letter, one lowercase letter, and one number" }

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    # update_attribute(:remember_digest, User.digest(remember_token))
    # This can be written as:
    update_attribute(:remember_digest, User.digest(@remember_token))
  end

  #this method is modified to use send method to call a method dynamically below
  # def authenticated?(remember_token)
  #   return false if remember_digest.nil?
  #   # method to verify if the remember_token matches the remember_digest.
  #   BCrypt::Password.new(remember_digest).is_password?(remember_token)
  # end

  #Example of meta programming .Send method is used to call a method dynamically
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    #method to verify if the token matches the digest.
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  #this method is called in account_activations_controller.rb
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # def activate
  #   update_columns(activated: true, activated_at: Time.zone.now)
  # end

  #this method is called in users_controller.rb and is defined in UserMailer
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    #here reset_token is a virtual attribute and @reset_token is set to a random token
    self.reset_token = User.new_token
    #when we write update_attribute it will update the database without calling the validations
    #But if we had used  self.reset_digest = User.digest(@reset_token) then we should call it somewhere like this user.save
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  #this method is called in password_resets_controller.rb and is defined in UserMailer
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token = User.new_token #activation_token= is a virtual attribute and here @activation_token is set to a random token
    self.activation_digest = User.digest(@activation_token) #activation_digest is a column in the database and here it is set to the digest of the activation_token
  end
end

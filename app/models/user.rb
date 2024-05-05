class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  before_create :create_activation_digest

  has_many :microposts, dependent: :destroy
  # active_relationships meaning all the users that the current user is following.
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  # this will give us methods like
  # active_relationships.follower and active_relationships.followed
  # user.active_relationships.create(followed_id: other_user.id)
  # user.active_relationships.find_by(followed_id: other_user.id).destroy
  # user.active_relationships.build(followed_id: other_user.id)

  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  # This code below is saying that the current user has many following through active_relationships and the source of the following is the followed users. So rails knows that the source is the followed_id in the relationships table.
  # in other words these line has_many:following and followers are defining association between users and relationships table not routes
  has_many :following, through: :active_relationships, source: :followed

  has_many :followers, through: :passive_relationships, source: :follower

  # before_save { self.email = email.downcase }
  before_save :downcase_email # We have defined method below in private section
  validates :name, presence: true
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    length: { maximum: 50 },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, length: { minimum: 5, maximum: 50 }, allow_nil: true,
                       format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+\z/, message: 'must include at least one uppercase letter, one lowercase letter, and one number' }

  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost:)
  end

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    # update_attribute(:remember_digest, User.digest(remember_token))
    # This can be written as:
    update_attribute(:remember_digest, User.digest(@remember_token))
  end

  # This method is called in sessions_helper.rb
  def forget
    update_attribute(:remember_digest, nil)
  end

  # this method is modified to use send method to call a method dynamically below
  # def authenticated?(remember_token)
  #   return false if remember_digest.nil?
  #   # method to verify if the remember_token matches the remember_digest.
  #   BCrypt::Password.new(remember_digest).is_password?(remember_token)
  # end

  # Example of meta programming .Send method is used to call a method dynamically
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    # method to verify if the token matches the digest.
    BCrypt::Password.new(digest).is_password?(token)
  end

  # this method is called in account_activations_controller.rb
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # def activate
  #   update_columns(activated: true, activated_at: Time.zone.now)
  # end

  # this method is called in users_controller.rb and is defined in UserMailer
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    # here reset_token is a virtual attribute and @reset_token is set to a random token
    self.reset_token = User.new_token
    # when we write update_attribute it will update the database without calling the validations
    # But if we had used  self.reset_digest = User.digest(@reset_token) then we should call it somewhere like this user.save
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # this method is called in password_resets_controller.rb and is defined in UserMailer
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # define a proto-feed
  # See "Following users" for the full implementation.
  def feed
    Micropost.where('user_id = ?', id)
  end

  # methods for following? follow and unfollow are defined here. These methods are available becuase of this line has_many :following, through: :active_relationships, source: :followed

  # Currently these methods are called in test .

  def follow(other_user)
    following << other_user

    #this above code is equivalent to this code below

    # active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    following.delete(other_user)
    # active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end


  private

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token = User.new_token # activation_token= is a virtual attribute and here @activation_token is set to a random token
    self.activation_digest = User.digest(@activation_token) # activation_digest is a column in the database and here it is set to the digest of the activation_token
  end
end

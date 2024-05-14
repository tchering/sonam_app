class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  # Staby lambda syntax to define a default scope that orders the microposts by their creation time in descending order without calling it.
  default_scope -> { order(created_at: :desc) }
  # default_scope = lambda {order(created_at: :desc)}

  #we can create named scope like this below which we can call in instance of Micropost model: @post = Micropost.by_user(@current_user) for example
  # scope :by_user, ->(user) { where(user_id: user.id) }
  #scope :by_user, lambda(user) { where(user_id: user.id)}
  # scope :by_user, lambda { |user| where(user_id: user.id) }

  validates :image, content_type: { in: ["image/png", "image/jpg", "image/jpeg", "image/gif"], message: "Only PNG, JPG, JPEG, and GIF files are allowed." },
                    size: { less_than: 5.megabytes, message: "Image should be less than 5MB" }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  # Returns a resized image for display.
  def display_image
    image.variant(resize_to_limit: [600, 600])
  end
end

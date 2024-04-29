class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  #Staby lambda syntax to define a default scope that orders the microposts by their creation time in descending order.
  default_scope -> { order(created_at: :desc) }

  validates :image, content_type: { in: ["image/png", "image/jpg", "image/jpeg", "image/gif"], message: "Only PNG, JPG, JPEG, and GIF files are allowed." },
                    size: { less_than: 5.megabytes, message: "Image should be less than 5MB" }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  # Returns a resized image for display.
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end

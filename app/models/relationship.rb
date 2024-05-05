class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  #   Relationship record must have a follower_id and a followed_id. If you try to save a Relationship record without one or both of these fields, Rails will prevent it and add an error message to the Relationship object.

  # This is important because a Relationship without a follower_id or followed_id wouldn't make sense in the context of your application. A relationship implies that one user (the follower) is following another user (the followed). If one or both of these users are missing, the relationship is incomplete.
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end

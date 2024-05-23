class Conversation < ApplicationRecord
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :recipent, class_name: 'User', foreign_key: 'recipent_id'

  has_many :messages, dependent: :destroy

  validates :sender_id, uniqueness: { scope: :recipent_id }
  # The line validates :sender_id, uniqueness: { scope: :recipent_id } means that the sender_id should be unique for each recipent_id.

  scope :between, lambda { |sender_id, recipent_id|
                    where(sender_id:, recipent_id:).or(where(sender_id: recipent_id, recipent_id: sender_id))
                  }
end

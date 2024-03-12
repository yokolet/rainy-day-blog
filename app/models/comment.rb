class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :reply, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: "reply_id", dependent: :destroy

  validates_presence_of :body
  validates_length_of :body, minimum: 1, maximum: 300
end

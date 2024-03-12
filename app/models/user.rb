class User < ApplicationRecord
  before_validation :set_default_token

  enum provider: [:twitter, :gitlab, :github]

  # validation
  validates_presence_of :identifier, :provider
  validates_uniqueness_of :identifier, scope: :provider
  validates_uniqueness_of :token

  # Association
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  private
  def set_default_token
    self.token = SecureRandom.uuid if self.token.blank?
  end
end

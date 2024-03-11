class User < ApplicationRecord
  before_validation :set_default_token

  enum provider: [:twitter, :gitlab, :github]

  validates_presence_of :identifier, :provider
  validates_uniqueness_of :identifier, scope: :provider
  validates_uniqueness_of :token

  private
  def set_default_token
    self.token = SecureRandom.uuid if self.token.blank?
  end
end

# frozen_string_literal: true

# AccessToken class
class AccessToken < ApplicationRecord
  belongs_to :user
  belongs_to :api_key, optional: true

  validates :user, presence: true

  def authenticate(unencrypted_token)
    BCrypt::Password.new(token_digest).is_password?(unencrypted_token)
  end

  def expired?
    created_at + 2.days < Time.now
  end

  # We generate the token before hashing it and saving it.
  # We also return it so we can send it to the client.
  def generate_token
    token = SecureRandom.hex
    digest = BCrypt::Password.create(token, cost: BCrypt::Engine.cost)
    update_column(:token_digest, digest)
    token
  end
end

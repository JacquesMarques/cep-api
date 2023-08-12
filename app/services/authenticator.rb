# frozen_string_literal: true

# Authenticator class
class Authenticator
  include ActiveSupport::SecurityUtils

  def initialize(authorization)
    @authorization = authorization
  end

  def credentials
    @credentials ||= @authorization.tr('-', '').scan(/(\w+)[:=] ?"?([\w|:]+)"?/).to_h
  end

  def api_key
    return nil if credentials['api_key'].blank?

    id, key = credentials['api_key'].split(':')
    api_key = id && key && ApiKey.activated.find_by(id: id)

    api_key if api_key && secure_compare_with_hashing(api_key.key, key)
  end

  def access_token
    return nil if credentials['access_token'].blank?

    id, token = credentials['access_token'].split(':')
    user = id && token && User.find_by(id: id)
    access_token = user && AccessToken.find_by(user: user)
    return nil unless access_token

    if access_token.expired?
      access_token.destroy
      return nil
    end

    access_token if access_token.authenticate(token)
  end

  private

  def secure_compare_with_hashing(key1, key2)
    secure_compare(Digest::SHA1.hexdigest(key1), Digest::SHA1.hexdigest(key2))
  end
end

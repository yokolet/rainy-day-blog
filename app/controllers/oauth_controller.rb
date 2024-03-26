class OauthController < ApplicationController
  def twitter
    code_verifier = @redis.get(params[:state])
    oauthTokenParams = {
      redirect_uri: 'http://www.localhost:3000/oauth/twitter',
      code: params[:code]
    }
    access_token, expires_in = getOAuthToken("https://api.twitter.com", "/2/oauth2/token",
                                             Rails.application.credentials.twitter.client_id,
                                             Rails.application.credentials.twitter.client_secret,
                                             code_verifier,
                                             oauthTokenParams)
    data = getUser("https://api.twitter.com", "/2/users/me", access_token)
    user = createOrUpdateUser(
      {
        identifier: data['username'],
        provider: User.providers[:twitter],
        token: access_token,
        token_expiry: DateTime.now.advance(seconds: expires_in.to_i)
      }
    )
    logger.debug("created or updated user: #{user}")
    signedToken = getSignedToken(data['username'], User.providers[:twitter])
    cookies[:user_info] = {
      value: { identifier: data['username'],
               provider: 'twitter',
               jwt: signedToken}.to_json,
      httponly: false }
    redirect_to(root_path)
  end

  private

  def getBasicAuthToken(client_id, client_secret)
    Base64.strict_encode64("#{client_id}:#{client_secret}")
  end

  def getOAuthToken(url, path, client_id, client_secret, code_verifier, oauth_token_params)
    oauth_token_params = oauth_token_params.merge({
                                                    grant_type: 'authorization_code',
                                                    client_id: client_id,
                                                    code_verifier: code_verifier
                                                  })
    logger.debug("oauth_token_params: #{oauth_token_params}")
    conn = Faraday.new(
      url: url,
      headers: {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Authorization' => "Basic #{getBasicAuthToken(client_id, client_secret)}"
      }
    )
    response = conn.post(path, URI.encode_www_form(oauth_token_params))
    logger.debug("response.status: #{response.status.inspect}")
    logger.debug("response.body: #{response.body.inspect}")
    body_obj = JSON.parse(response.body)
    [body_obj['access_token'], body_obj['expires_in']]
  end

  def getUser(url, path, access_token)
    conn = Faraday.new(
      url: url,
      headers: {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Authorization' => "Bearer #{access_token}"
      }
    )
    response = conn.get(path)
    logger.debug("response.status: #{response.status.inspect}")
    logger.debug("response.body: #{response.body.inspect}")
    body_obj = JSON.parse(response.body)
    body_obj['data']
  end

  def createOrUpdateUser(user)
    User.upsert(user,
                unique_by: [:identifier, :provider],
                on_duplicate: :update,
                update_only: [:token, :token_expiry])
  end

  def getSignedToken(identifier, provider)
    JWT.encode(
      {
        identifier: identifier,
        provider: provider,
      },
      Rails.application.credentials.jwt_secret,
      'HS256'
    )
  end
end

class PkceController < ApplicationController
  def twitter
    verifier = generate_code_verifier
    state = generate_state
    pkce = {
      redirect_uri: 'http://www.localhost:3000/oauth/twitter',
      client_id: Rails.application.credentials.twitter.client_id.strip,
      response_type: 'code',
      code_challenge: generate_code_challenge(verifier),
      code_challenge_method: 'S256',
      scope: ['users.read', 'tweet.read', 'follows.read', 'follows.write'].join(' '),
      state: state,
    }
    cookies[:pkce] = { value: pkce.to_json, httponly: false }
    @redis.set(state, verifier, ex: 60.minutes)
    render json: pkce.to_json
  end

  private

  def generate_code_verifier(length: 48)
    SecureRandom.base64((length * 3) / 4).tr("+/", "-_").tr("=", "")
  end

  def generate_code_challenge(code_verifier)
    Digest::SHA256.base64digest(code_verifier).tr("+/", "-_").tr("=", "")
  end

  def generate_state
    SecureRandom.uuid
  end
end

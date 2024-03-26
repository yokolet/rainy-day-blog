require 'rails_helper'

RSpec.describe "Oauths", type: :request do
  describe "GET /twitter" do
    before do
      redis = Redis.new(Rails.application.config.redis_db)
      redis.set('state', 'verifier9876')
    end

    it "returns http success" do
      stub_request(:post, "https://api.twitter.com/2/oauth2/token").
        with(
          headers: {
            'Accept'=>'*/*',
            'User-Agent'=>'Faraday v2.9.0'
          }).
        to_return(status: 200, body: {access_token: 'token', expires_in: 'tomorrow'}.to_json, headers: {})

      stub_request(:get, "https://api.twitter.com/2/users/me").
        with(
          headers: {
            'Accept'=>'*/*',
            'User-Agent'=>'Faraday v2.9.0'
          }).
        to_return(status: 200, body: {data: {username: 'username', name: 'who'}}.to_json, headers: {})

      get "/oauth/twitter", params: {state: 'state', code: 'code1234'}
      expect(response).to have_http_status(:redirect)
    end
  end

end

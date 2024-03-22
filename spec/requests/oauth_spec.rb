require 'rails_helper'

RSpec.describe "Oauths", type: :request do
  describe "GET /twitter" do
    before do
      redis = Redis.new(Rails.application.config.redis_db)
      redis.set('state', 'verifier9876')
    end

    it "returns http success" do
      get "/oauth/twitter", params: {state: 'state', code: 'code1234'}
      expect(response).to have_http_status(:redirect)
    end
  end

end

require 'rails_helper'

RSpec.describe "Pkces", type: :request do
  describe "GET /twitter" do
    it "returns http success" do
      get "/pkce/twitter"
      expect(response).to have_http_status(:success)
    end
  end

end

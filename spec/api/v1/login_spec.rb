# spec/api/v1/login_spec.rb

require 'rails_helper'

RSpec.describe V1::Login, type: :request do
  let(:base_url) { "/api/v1/login" }
  let(:email) { "user@example.com" }
  let(:password) { "password123" }

  before do
    @user = create(:user, email: email, password: password)
  end

  describe "POST /api/v1/login" do
    context "with valid credentials" do
      it "returns a JWT token" do
        post base_url, params: { email: email, password: password }

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)

        expect(json_response["user"]["id"]).to eq(@user.id)
        expect(json_response["user"]["email"]).to eq(@user.email)
        expect(json_response["token"]).not_to be_nil
      end
    end

    context "with invalid credentials" do
      it "returns an error" do
        post base_url, params: { email: email, password: "wrong_password" }

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)

        expect(json_response["error"]).to eq("Unauthorized")
      end
    end
  end
end
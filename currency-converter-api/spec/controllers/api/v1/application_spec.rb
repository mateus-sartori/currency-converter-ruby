require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_token) { JwtAuthService.generate_jwt_token(user_id: user.id) }
  let(:invalid_token_string) { 'invalid.token.here' }
  let(:expired_token) do
    payload = {
      sub: user.id,
      jti: SecureRandom.uuid,
      iat: Time.now.to_i - 3600,
      exp: Time.now.to_i - 1
    }
    JWT.encode(payload, ENV.fetch('DEVISE_JWT_SECRET_KEY', 'default_secret_key_for_test'), 'HS256')
  end

  controller do
    def index
      render json: { message: 'success' }, status: :ok
    end
  end

  describe "JWT token authentication" do
    context "with valid token" do
      it "grants access" do
        request.headers['Authorization'] = "Bearer #{valid_token}"
        get :index
        expect(response).to have_http_status(:ok)
      end
    end

    context "with missing token" do
      it "returns unauthorized (401)" do
        request.headers['Authorization'] = nil
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid token" do
      it "returns unauthorized (401)" do
        request.headers['Authorization'] = "Bearer #{invalid_token_string}"
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with expired token" do
      it "returns unauthorized (401)" do
        request.headers['Authorization'] = "Bearer #{expired_token}"
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with token in denylist" do
      it "returns unauthorized (401)" do
        allow(JwtAuthService).to receive(:token_is_in_denylist?).and_return(true)
        allow(JwtAuthService).to receive(:decode_jwt_payload).and_return({ 'user_id' => user.id, 'jti' => 'some_jti' })

        request.headers['Authorization'] = "Bearer #{valid_token}"
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

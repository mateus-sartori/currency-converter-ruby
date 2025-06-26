require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:transactions) { create_list(:transaction, 5, user: user) }
  let!(:other_transactions) { create_list(:transaction, 3, user: other_user) }
  let(:token) { JwtAuthService.generate_jwt_token(user_id: user.id) }

  before do
    request.headers['Authorization'] = "Bearer #{token}"
  end

  describe 'GET #index' do
    context 'when user has transactions' do
      it 'returns all user transactions' do
        get :index, params: { user_id: user.id }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).count).to eq(5)
        expect(JSON.parse(response.body).first['user_id']).to eq(user.id)
      end

      it 'does not return transactions from other users' do
        get :index, params: { user_id: user.id }

        response_transactions = JSON.parse(response.body)
        other_user_ids = response_transactions.map { |t| t['user_id'] }.uniq

        expect(other_user_ids).not_to include(other_user.id)
      end
    end

    context 'when user has no transactions' do
      it 'returns an empty list' do
        Transaction.where(user: user).destroy_all
        get :index, params: { user_id: user.id }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to be_empty
      end
    end

    context 'when JWT token is invalid' do
      it 'returns unauthorized status' do
        request.headers['Authorization'] = "Bearer invalid_token"
        get :index, params: { user_id: user.id }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authorization header is missing' do
      it 'returns unauthorized status' do
        request.headers['Authorization'] = nil
        get :index, params: { user_id: user.id }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

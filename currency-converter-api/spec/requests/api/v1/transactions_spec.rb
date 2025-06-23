require 'rails_helper'

RSpec.describe "Api::V1::Transactions", type: :request do
  let(:user) { create(:user) }
  let(:valid_attributes) do
    {
      transaction: {
        user_id: user.id,
        from_currency: "USD",
        to_currency: "BRL",
        from_value: 100.0
      }
    }
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new transaction" do
        expect do
          post api_v1_transactions_path, params: valid_attributes
        end.to change(Transaction, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(json_response).to include("id", "from_currency", "to_currency", "from_value", "to_value", "rate")
      end
    end

    context "with invalid parameters" do
      it "returns an error" do
        post api_v1_transactions_path, params: { transaction: { user_id: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response).to have_key("error")
      end
    end
  end

  describe "GET /index" do
    let!(:transaction) { create(:transaction, user_id: user.id) }

    it "returns a list of transactions for the user" do
      get api_v1_transactions_path, params: { user_id: user.id }
      expect(response).to have_http_status(:ok)
      expect(json_response).to be_an(Array)
      expect(json_response.first["id"]).to eq(transaction.id)
    end

    it "returns an empty array if no transactions exist" do
      get api_v1_transactions_path, params: { user_id: 999 }
      expect(response).to have_http_status(:ok)
      expect(json_response).to eq([])
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end

module Api
  module V1
    # Handles API requests for transactions, including creation and listing.
    class TransactionsController < ApplicationController
      def create
        @transaction = Transactions::CreateTransactionService.call(transaction_params)
        render json: @transaction, status: :created
      rescue StandardError => e
        render json: { message: e.message }, status: :unprocessable_entity
      end

      def index
        @transactions = Transactions::IndexTransactionService.call(params[:user_id])
        render json: @transactions
      end

      private

      def transaction_params
        params.require(:transaction).permit(
          :user_id,
          :from_currency,
          :to_currency,
          :from_value
        )
      end
    end
  end
end

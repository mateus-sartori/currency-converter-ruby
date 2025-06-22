# app/controllers/api/v1/transactions_controller.rb
class Api::V1::TransactionsController < ApplicationController
  def create
    @transaction = Transactions::CreateTransactionService.call(transaction_params)
    render json: @transaction, status: :created
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def index
    @transactions = Transaction.where(user_id: params[:user_id])
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




 

# app/controllers/api/v1/transactions_controller.rb
class Api::V1::TransactionsController < ApplicationController
  def create
    service = CurrencyConverterService.new
    rate = service.convert(from: params[:from_currency], to: params[:to_currency])
    to_value = params[:from_value].to_f * rate

    transaction = Transaction.create!(
      user_id: params[:user_id],
      from_currency: params[:from_currency],
      to_currency: params[:to_currency],
      from_value: params[:from_value],
      to_value: to_value,
      rate: rate,
      timestamp: Time.now.utc
    )

    render json: transaction_response(transaction), status: :created
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def index
    transactions = Transaction.where(user_id: params[:user_id])
    render json: transactions.map { |t| transaction_response(t) }
  end

  private

  def transaction_response(t)
    {
      transaction_id: t.id,
      user_id: t.user_id,
      from_currency: t.from_currency,
      to_currency: t.to_currency,
      from_value: t.from_value.to_f,
      to_value: t.to_value.to_f,
      rate: t.rate.to_f,
      timestamp: t.timestamp.iso8601
    }
  end
end




 

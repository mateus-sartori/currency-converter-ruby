class Transactions::CreateTransactionService < ApplicationService
  def initialize(params)
    @user_id = params[:user_id]
    @from_currency = params[:from_currency]
    @to_currency = params[:to_currency]
    @from_value = params[:from_value].to_f
  end

  def call
    rate = fetch_conversion_rate
    to_value = calculate_converted_value(rate)
    
    create_transaction(rate, to_value)
  end

  private

  def fetch_conversion_rate
    currency_service = CurrencyConverterService.new
    currency_service.convert(from: @from_currency, to: @to_currency)
  rescue => e
    raise StandardError, "Erro ao obter taxa de conversão: #{e.message}"
  end

  def calculate_converted_value(rate)
    @from_value * rate
  end

  def create_transaction(rate, to_value)
    transaction = Transaction.new(
      user_id: @user_id,
      from_currency: @from_currency,
      to_currency: @to_currency,
      from_value: @from_value,
      to_value: to_value,
      rate: rate,
      timestamp: Time.now.utc
    )
    transaction.save!
    transaction
  rescue => e
    raise StandardError, transaction.errors.full_messages.join(', ')
  end
end

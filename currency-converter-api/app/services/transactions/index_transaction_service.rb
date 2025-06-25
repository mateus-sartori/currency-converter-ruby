class Transactions::IndexTransactionService < ApplicationService
  def initialize(user_id)
    @user_id = user_id
  end

  def call
    Transaction.where(user_id: @user_id).order(created_at: :desc)
  rescue StandardError => e
    raise StandardError, "Error fetching transactions: #{e.message}"
  end
end

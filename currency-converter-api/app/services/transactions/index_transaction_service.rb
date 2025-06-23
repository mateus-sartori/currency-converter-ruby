class Transactions::IndexTransactionService < ApplicationService
  def initialize(user_id, page: 1, per_page: 10)
    @user_id = user_id
    @page = page
    @per_page = per_page
  end

  def call
    Transaction.where(user_id: @user_id).order(created_at: :desc).paginate(page: @page, per_page: @per_page)
  rescue StandardError => e
    raise StandardError, "Error fetching transactions: #{e.message}"
  end
end

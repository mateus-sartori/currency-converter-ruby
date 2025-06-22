class TransactionSerializer < ActiveModel::Serializer
  attributes :transaction_id, :user_id, :from_currency, :to_currency, :from_value, :to_value, :rate, :timestamps

  def transaction_id
    object.id
  end

  def timestamps
    object.created_at
  end
end

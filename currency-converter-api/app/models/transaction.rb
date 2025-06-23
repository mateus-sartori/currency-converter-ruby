class Transaction < ApplicationRecord
  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :from_currency, presence: true, length: { is: 3 }
  validates :to_currency, presence: true, length: { is: 3 }
  validates :from_value, presence: true, numericality: { greater_than: 0 }
  validates :rate, presence: true, numericality: { greater_than: 0 }

  validate :currencies_are_different

  private

  def currencies_are_different
    if from_currency == to_currency
      errors.add(:base, 'The currencies are the same. Please you need to convert to a different currency.')
    end
  end
end

FactoryBot.define do
  factory :transaction do
    user_id { 1 }
    from_currency { "USD" }
    to_currency { "BRL" }
    from_value { "10" }
    to_value { "15" }
    rate { "5.51" }
    timestamp { "2025-06-22 22:30:29" }
  end
end

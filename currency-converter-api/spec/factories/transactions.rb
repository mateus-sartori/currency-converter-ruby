FactoryBot.define do
  factory :transaction do
    association :user
    from_currency { "USD" }
    to_currency { "BRL" }
    from_value { 10.0 }
    to_value { 15.0 }
    rate { 5.51 }
  end
end

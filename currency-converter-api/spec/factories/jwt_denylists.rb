FactoryBot.define do
  factory :jwt_denylist do
    jti { "MyString" }
    exp { "2025-06-23 00:59:14" }
  end
end

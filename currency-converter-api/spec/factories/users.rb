FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { 'password123' }
    encrypted_password { Devise::Encryptor.digest(User, password) }
  end
end

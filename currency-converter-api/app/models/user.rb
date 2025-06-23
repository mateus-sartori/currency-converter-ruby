class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable,
         :registerable,
         :trackable,
         :recoverable,
         :rememberable,
         :validatable,
         :lockable,
         :jwt_authenticatable,
         jwt_revocation_strategy: self
end

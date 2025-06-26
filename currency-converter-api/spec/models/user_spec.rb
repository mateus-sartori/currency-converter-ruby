require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    it { is_expected.to have_many(:transactions).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe 'Devise modules' do
    it 'includes the correct Devise modules' do
      expect(described_class.devise_modules).to include(
        :database_authenticatable,
        :registerable,
        :trackable,
        :recoverable,
        :rememberable,
        :validatable,
        :lockable,
        :jwt_authenticatable
      )
    end
  end

  describe 'JWT' do
    it 'uses Denylist revocation strategy' do
      expect(described_class.jwt_revocation_strategy).to eq(described_class)
    end

    it 'includes Denylist strategy' do
      expect(described_class.ancestors).to include(Devise::JWT::RevocationStrategies::Denylist)
    end
  end

  describe 'factory' do
    it 'is valid' do
      expect(user).to be_valid
    end
  end
end

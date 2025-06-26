require 'rails_helper'

RSpec.describe JwtDenylist, type: :model do
  let(:jwt_denylist) { create(:jwt_denylist) }

  describe 'associations' do
    it { is_expected.to be_a_kind_of(ApplicationRecord) }
  end

  describe 'table name' do
    it 'uses the correct table name' do
      expect(described_class.table_name).to eq('jwt_denylists')
    end
  end

  describe 'Devise JWT integration' do
    it 'includes Denylist revocation strategy' do
      expect(described_class.ancestors).to include(Devise::JWT::RevocationStrategies::Denylist)
    end
  end

  describe 'validations' do
    it 'validates presence of jti' do
      expect(jwt_denylist).to validate_presence_of(:jti)
    end

    it 'validates presence of exp' do
      expect(jwt_denylist).to validate_presence_of(:exp)
    end
  end
end

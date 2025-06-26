require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user) { create(:user) }
  let(:valid_attributes) do
    {
      user: user,
      from_currency: 'USD',
      to_currency: 'BRL',
      from_value: 10.0,
      rate: 5.51
    }
  end
  let(:transaction) { create(:transaction, valid_attributes) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    subject { Transaction.new(valid_attributes) }

    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_numericality_of(:user_id).only_integer }
    it { is_expected.to validate_presence_of(:from_currency) }
    it { is_expected.to validate_length_of(:from_currency).is_equal_to(3) }
    it { is_expected.to validate_presence_of(:to_currency) }
    it { is_expected.to validate_length_of(:to_currency).is_equal_to(3) }
    it { is_expected.to validate_presence_of(:from_value) }
    it { is_expected.to validate_numericality_of(:from_value).is_greater_than(0) }
    it { is_expected.to validate_presence_of(:rate) }
    it { is_expected.to validate_numericality_of(:rate).is_greater_than(0) }

    context 'when currencies are the same' do
      before { subject.from_currency = subject.to_currency }

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:base]).to include('The currencies are the same. Please you need to convert to a different currency.')
      end
    end
  end

  describe 'enumerations' do
    it { is_expected.to respond_to(:from_currency) }
    it { is_expected.to respond_to(:from_currency_humanize) }
    it { is_expected.to respond_to(:to_currency) }
    it { is_expected.to respond_to(:to_currency_humanize) }

    it 'usa a enumeração correta para from_currency' do
      expect(Transaction.enumerations[:from_currency]).to eq(CurrencyEnumeration)
    end

    it 'usa a enumeração correta para to_currency' do
      expect(Transaction.enumerations[:to_currency]).to eq(CurrencyEnumeration)
    end
  end

  describe 'factory' do
    it 'is valid' do
      expect(transaction).to be_valid
    end
  end
end

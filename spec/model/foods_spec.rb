require 'rails_helper'

RSpec.describe Food, type: :model do
  describe 'validations' do
    let(:user) { User.create(name: 'Salma') }
    subject { Food.create(name: 'Apple', measurement_unit: 'kg', price: 1.99, quantity: 1.0, user_id: user) }
    
    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid without a price' do
      subject.price = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid with a price less than 0' do
      subject.price = -1
      expect(subject).not_to be_valid
    end
  end
end

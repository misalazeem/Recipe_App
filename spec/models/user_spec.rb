require 'rails_helper'

RSpec.describe User, type: :model do
  it 'should create a valid user' do
    user = User.create(name: 'John Doe', email: 'john@example.com', password: 'password')
    expect(user.valid?).to eq true
  end

  it 'should not create a user without a name' do
    user = User.create(email: 'john@example.com', password: 'password')
    expect(user.valid?).to eq false
  end

  it 'should have many recipes' do
    user = User.reflect_on_association(:recipes)
    expect(user.macro).to eq(:has_many)
  end

  it 'should have many foods' do
    user = User.reflect_on_association(:foods)
    expect(user.macro).to eq(:has_many)
  end
end

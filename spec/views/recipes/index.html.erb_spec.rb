require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.feature 'Recipes Index', type: :feature do
  include Warden::Test::Helpers
  before do
    user = User.create(email: 'user@example.com', password: 'password', name: 'user123')
    login_as user, scope: :user
  end

  it 'User views the list of recipes' do
    user = User.create(email: 'user@example.com', password: 'password', name: 'user123')
    login_as user, scope: :user
    recipe1 = Recipe.create(
      user_id: user.id,
      name: 'Recipe 1',
      description: 'Description 1',
      preparation_time: 30,
      cooking_time: 45
    )
    puts recipe1.name
    visit recipes_path
    expect(page).to have_content('Your Recipes')
  end

  it 'User does not see recipes from other users' do
    user1 = User.create(email: 'user1@example.com', password: 'password', name: 'user1')
    user2 = User.create(email: 'user2@example.com', password: 'password', name: 'user2')
    Recipe.create(
      user_id: user1.id,
      name: 'User 1 Recipe',
      preparation_time: 20,
      cooking_time: 35
    )
    Recipe.create(
      user_id: user2.id,
      name: 'User 2 Recipe',
      preparation_time: 25,
      cooking_time: 40
    )
    login_as user1, scope: :user
    visit recipes_path
    expect(page).to have_content('User 1 Recipe')
    expect(page).not_to have_content('User 2 Recipe')
  end

  after do
    Warden.test_reset!
  end
end
# rubocop:enable Metrics/BlockLength

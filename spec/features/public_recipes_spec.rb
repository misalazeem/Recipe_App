require 'rails_helper'

RSpec.feature 'Public Recipes', type: :feature do
  scenario 'User views public recipes' do
    user = User.create(name: 'John', email: 'john@example.com', password: 'password')

    Recipe.create(name: 'Sample Recipe 1', user:)
    Recipe.create(name: 'Sample Recipe 2', user:)

    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'

    visit public_recipes_recipes_path
    expect(page).to have_content('Public Recipes')
  end
end

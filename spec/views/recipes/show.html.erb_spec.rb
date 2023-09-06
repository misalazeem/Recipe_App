require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.feature 'Recipe Show Page', type: :feature do
  include Warden::Test::Helpers
  before do
    @user = User.create(email: 'user@example.com', password: 'password', name: 'user123')

    @recipe = Recipe.create(
      user: @user,
      name: 'Test Recipe',
      preparation_time: 30,
      cooking_time: 45,
      description: 'This is a test recipe description.',
      public: true
    )

    @food1 = Food.create(
      user: @user,
      name: 'Ingredient 1',
      quantity: 2,
      measurement_unit: 'cups',
      price: 10.99
    )

    @food2 = Food.create(
      user: @user,
      name: 'Ingredient 2',
      quantity: 1,
      measurement_unit: 'tablespoon',
      price: 5.99
    )
    RecipeFood.create(recipe: @recipe, food: @food1, quantity: 2)
    RecipeFood.create(recipe: @recipe, food: @food2, quantity: 1)
  end

  scenario 'displays recipe details' do
    visit recipe_path(@recipe)

    expect(page).to have_content('Test Recipe')
    expect(page).to have_content('Preparation Time: 30 minutes')
    expect(page).to have_content('Cooking Time: 45 minutes')
    expect(page).to have_content('This is a test recipe description.')
  end

  scenario 'displays Make Private button for the recipe owner' do
    login_as @user, scope: :user

    visit recipe_path(@recipe)

    expect(page).to have_link('Make Private')
  end

  scenario 'does not display Make Private button for other users' do
    other_user = User.create(email: 'other@example.com', password: 'password', name: 'otheruser')
    login_as other_user, scope: :user

    visit recipe_path(@recipe)

    expect(page).not_to have_link('Make Private')
  end

  scenario 'displays Remove Food button for the recipe owner' do
    login_as @user, scope: :user

    visit recipe_path(@recipe)

    expect(page).to have_button('Remove Food', count: 2)
  end

  scenario 'does not display Remove Food button for other users' do
    other_user = User.create(email: 'other@example.com', password: 'password', name: 'otheruser')
    login_as other_user, scope: :user

    visit recipe_path(@recipe)

    expect(page).not_to have_button('Remove Food')
  end

  scenario 'displays food items' do
    visit recipe_path(@recipe)

    expect(page).to have_content('Ingredient 1')
    expect(page).to have_content('2.0 cups')
    expect(page).to have_content('$10.99')
    expect(page).to have_content('Ingredient 2')
    expect(page).to have_content('1.0 tablespoon')
    expect(page).to have_content('$5.99')
  end

  scenario 'provides a link to go back to the recipe index' do
    visit recipe_path(@recipe)

    expect(page).to have_link('Back to Recipes', href: recipes_path)
  end

  after do
    Warden.test_reset!
  end
end
# rubocop:enable Metrics/BlockLength

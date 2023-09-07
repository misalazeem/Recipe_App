require 'rails_helper'

RSpec.describe Recipe, type: :model do
  it 'should create a valid recipe' do
    user = User.create(name: 'John Doe', email: 'john@example.com', password: 'password')
    recipe = user.recipes.create(name: 'Spaghetti Carbonara', description: 'Delicious pasta dish')
    expect(recipe.valid?).to eq true
  end

  it 'should belong to a user' do
    recipe = Recipe.reflect_on_association(:user)
    expect(recipe.macro).to eq(:belongs_to)
  end

  it 'should have many recipe_foods' do
    recipe = Recipe.reflect_on_association(:recipe_foods)
    expect(recipe.macro).to eq(:has_many)
  end

  it 'should have many foods through recipe_foods' do
    recipe = Recipe.reflect_on_association(:foods)
    expect(recipe.macro).to eq(:has_many)
    expect(recipe.options[:through]).to eq(:recipe_foods)
  end
end

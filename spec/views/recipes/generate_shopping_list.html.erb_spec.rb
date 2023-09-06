require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'recipes/generate_shopping_list.html.erb', type: :view do
  before do
    @user = User.create(
      email: 'user@example.com',
      password: 'password',
      name: 'user'
    )

    @recipe = Recipe.create(
      name: 'Test Recipe',
      preparation_time: 30,
      cooking_time: 45,
      description: 'This is a test recipe description.',
      user: @user
    )

    @required_foods = [
      Food.new(name: 'Ingredient 1', quantity: 2.0, measurement_unit: 'cups', price: 10.99),
      Food.new(name: 'Ingredient 2', quantity: 1.0, measurement_unit: 'tablespoon', price: 5.99)
    ]

    @total_value = @required_foods.sum { |food| food.price * food.quantity }
    login_as @user
  end

  it 'displays the title' do
    render
    expect(rendered).to have_content('Generate Shopping List')
  end

  it 'displays the amount of food items to buy' do
    render
    expect(rendered).to have_content("Amount of food items to buy: #{@required_foods.count}")
  end

  it 'displays the total value of food needed' do
    render
    expect(rendered).to have_content("Total Value of food needed: $#{format('%.2f', @total_value)}")
  end

  it 'displays a table of required food items' do
    render
    @required_foods.each do |food|
      expect(rendered).to have_content(food.name)
      expect(rendered).to have_content(food.quantity)
      expect(rendered).to have_content(food.measurement_unit)
      expect(rendered).to have_content("$#{food.price * food.quantity}")
    end
  end

  it 'displays a "Back to Recipe" link' do
    render
    expect(rendered).to have_link('Back to Recipe', href: recipe_path(@recipe))
  end

  after do
    Warden.test_reset!
  end
end

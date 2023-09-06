require 'rails_helper'

RSpec.describe RecipesController, type: :controller do
  let(:user) { User.create(name: 'Test User', email: 'user@example.com', password: 'password') }
  let(:recipe) { Recipe.create(name: 'Test Recipe', user: user) }

  before { sign_in user }

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @recipes containing user\'s recipes' do
      get :index
      expect(assigns(:recipes)).to eq(user.recipes)
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end

    it 'assigns a new recipe to @recipe' do
      get :new
      expect(assigns(:recipe)).to be_a_new(Recipe)
    end
  end

describe 'POST #create' do
  let(:valid_params) { { recipe: { name: 'New Recipe', user_id: user.id } } }

  it 'creates a new recipe with valid parameters' do
    expect {
      post :create, params: valid_params
    }.to change(Recipe, :count).by(1)
    expect(response).to redirect_to(recipe_path(Recipe.last))
  end
end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: recipe.id }
      expect(response).to be_successful
    end

    it 'assigns the requested recipe to @recipe' do
      get :show, params: { id: recipe.id }
      expect(assigns(:recipe)).to eq(recipe)
    end
  end

  describe 'GET #add_ingredient' do
    it 'returns a successful response' do
      get :add_ingredient, params: { id: recipe.id }
      expect(response).to be_successful
    end

    it 'assigns the requested recipe to @recipe' do
      get :add_ingredient, params: { id: recipe.id }
      expect(assigns(:recipe)).to eq(recipe)
    end
  end

  describe 'DELETE #remove_food' do
    let(:food) { Food.create(name: 'Test Food', user: user, price: 5.0, quantity: 2.0) }

    it 'removes food from the recipe' do
      recipe.foods << food
      expect {
        delete :remove_food, params: { id: recipe.id, food_id: food.id }
      }.to change(recipe.foods, :count).by(-1)
    end
  end

  describe 'GET #public_recipes' do
    it 'returns a successful response' do
      get :public_recipes
      expect(response).to be_successful
    end

    it 'assigns public recipes to @public_recipes' do
      public_recipe = Recipe.create(name: 'Public Recipe', user: user, public: true)
      get :public_recipes
      expect(assigns(:public_recipes)).to eq([public_recipe])
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the recipe' do
      recipe
      expect {
        delete :destroy, params: { id: recipe.id }
      }.to change(Recipe, :count).by(-1)
    end
  end

  describe 'PATCH #toggle_recipe_public' do
    it 'toggles the recipe\'s public status' do
      expect {
        patch :toggle_recipe_public, params: { id: recipe.id }
      }.to change { recipe.reload.public }.from(false).to(true)
    end
  end

  describe 'GET #generate_shopping_list' do
    let(:other_user) { User.create(name: 'Other User', email: 'other@example.com', password: 'password') }
    let(:food) { Food.create(name: 'Test Food', user: other_user, price: 5, quantity: 2) }

    before { recipe.foods << food }

    it 'returns a successful response' do
      get :generate_shopping_list, params: { id: recipe.id }
      expect(response).to be_successful
    end

    it 'assigns required foods to @required_foods' do
      get :generate_shopping_list, params: { id: recipe.id }
      expect(assigns(:required_foods)).to eq([food])
    end

    it 'calculates the total value correctly' do
      get :generate_shopping_list, params: { id: recipe.id }
      expect(assigns(:total_value)).to eq(10)
    end
  end
end
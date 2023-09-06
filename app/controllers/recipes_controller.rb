class RecipesController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def index
    @recipes = current_user.recipes
  end

  def public_recipes
    @public_recipes = Recipe.where(public: true).includes(:foods)
    @total_food_items = Food.sum(:quantity)
    @total_price = Food.joins(:recipe_foods).sum('foods.quantity * foods.price')
  end

  def destroy
    puts 'Destroy action executed.'
    @recipe = Recipe.find(params[:id])
    if @recipe.user == current_user
      @recipe.destroy
      flash[:notice] = 'Recipe deleted successfully.'
    else
      flash[:alert] = 'You do not have permission to delete this recipe.'
    end
    redirect_to recipes_path
  end

  def show
    @recipe = Recipe.find(params[:id])
  end
end

class RecipesController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def index
    @recipes = current_user.recipes
  end

  def add_ingredient
    @recipe = Recipe.find(params[:id])
  
    if current_user == @recipe.user
      @foods_not_in_recipe = Food.where.not(id: @recipe.foods.pluck(:id))
  
      if params[:recipe].present? && params[:recipe][:food_ids].present?
        food_ids = params[:recipe][:food_ids].reject(&:empty?) # Remove empty strings
        @recipe.foods << Food.where(id: food_ids)
        flash[:notice] = 'Ingredients added successfully.'
        redirect_to @recipe
        return
      end
    else
      flash[:alert] = 'You do not have permission to add ingredients to this recipe.'
    end
  
    render 'add_ingredient'
  end
  

  def remove_food
    @recipe = Recipe.find(params[:id])
    @food = Food.find(params[:food_id])
    if current_user == @recipe.user
      @recipe.foods.delete(@food)
      flash[:notice] = 'Ingredient removed successfully.'
    else
      flash[:alert] = 'You do not have permission to remove ingredients from this recipe.'
    end
    redirect_to @recipe
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
    @toggle_recipe_public = params[:toggle_recipe_public]
    if @toggle_recipe_public && @recipe.user == current_user
      @recipe.update(public: !@recipe.public)
      flash[:notice] = @recipe.public ? 'Recipe is now public.' : 'Recipe is now private.'
      redirect_to recipe_path(@recipe)
    end
  end

  def toggle_recipe_public
    @recipe = Recipe.find(params[:id])
    
    if @recipe.user == current_user
      @recipe.update(public: !@recipe.public)
      flash[:notice] = @recipe.public ? 'Recipe is now public.' : 'Recipe is now private.'
    else
      flash[:alert] = 'You do not have permission to toggle this recipe.'
    end
  
    redirect_to @recipe
  end
end

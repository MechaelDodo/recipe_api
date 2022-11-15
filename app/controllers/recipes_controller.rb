# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :authorize
  before_action :set_recipe, only: %i[show update destroy add_to_cart]

  # GET /recipes
  def index
    @recipes = Recipe.all

    # render json: @recipes
  end

  # GET /recipes/1
  def show; end

  # POST /recipes
  def create
    ActiveRecord::Base.transaction do
      @recipe = Recipe.create(recipe_params.merge(user: @user))
      Ingredient.find(params[:ingredients]).each { |ingredient| @recipe.ingredients << ingredient }
      if @user.first_recipe == false
        RecipeMailer.with(user: @user, recipe: @recipe).recipe_created.deliver_later
        @user.first_recipe = true
      end
      render json: @recipe, status: :created, location: @recipe
    end
  rescue ActiveRecord::TransactionIsolationError => e
    render json: e, status: :unprocessable_entity
  end

  def add_to_cart
    @recipe.ingredients.each do |ingredient|
      CartIngredient.create(cart_id: params[:cart_id],
                            ingredient_id: ingredient.id, user_id: @user.id)
    end
    render json: @recipe, location: @recipe
  end

  # PATCH/PUT /recipes/1
  def update
    ActiveRecord::Base.transaction do
      # place which somebody must rewrite because delete then create is a bad practice for update
      unless params[:ingredients].nil?
        # @recipe.ingredients.update(params[:ingredients])
        @recipe.ingredients.clear
        Ingredient.find(params[:ingredients]).each { |ingredient| @recipe.ingredients << ingredient }
      end
      @recipe.update(recipe_params) unless recipe_params.nil?
      render json: @recipe
    end
  rescue ActiveRecord::TransactionIsolationError => e
    render json: e, status: :unprocessable_entity
  end

  # DELETE /recipes/1
  def destroy
    ActiveRecord::Base.transaction do
      @recipe.ingredients.clear
      @recipe.destroy
    end
  rescue ActiveRecord::TransactionIsolationError => e
    render json: e, status: :unprocessable_entity
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def recipe_params
    params.require(:recipe).permit(:title, :description, :image)
  end
end

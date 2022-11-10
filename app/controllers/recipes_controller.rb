class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[show update destroy]

  # GET /recipes
  def index
    @recipes = Recipe.all
  end

  # GET /recipes/1
  def show
  end

  # POST /recipes
  def create
    ActiveRecord::Base.transaction do
      @recipe = Recipe.create(recipe_params)
      Ingredient.find(params[:ingredients]).each { |ingredient| @recipe.ingredients << ingredient }
      render json: @recipe, status: :created, location: @recipe
    end
  rescue ActiveRecord::TransactionIsolationError => exception
    render json: exception, status: :unprocessable_entity
  end

  # PATCH/PUT /recipes/1
  def update
    ActiveRecord::Base.transaction do
      # place which somebody must rewrite because delete then create is a bad practice for update
      unless params[:ingredients].nil?
        @recipe.ingredients.clear
        Ingredient.find(params[:ingredients]).each { |ingredient| @recipe.ingredients << ingredient }
      end
      @recipe.update(recipe_params) unless recipe_params.nil?
      render json: @recipe
    end
  rescue ActiveRecord::TransactionIsolationError => exception
    render json: exception, status: :unprocessable_entity
  end

  # DELETE /recipes/1
  def destroy
    ActiveRecord::Base.transaction do
      @recipe.ingredients.clear
      @recipe.destroy
    end
  rescue ActiveRecord::TransactionIsolationError => exception
    render json: exception, status: :unprocessable_entity
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def recipe_params
    params.require(:recipe).permit(:title, :description, :image, :user_id)
  end
end

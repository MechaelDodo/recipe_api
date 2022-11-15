# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :authorize
  before_action :set_recipe, only: %i[show update destroy add_to_cart]

  # GET /recipes
  def index
    @recipes = params[:search].nil? || params[:search].empty? ? Recipe.all : search_recipes
  end

  # GET /recipes/1
  def show; end

  # POST /recipes
  def create
    ActiveRecord::Base.transaction do
      @recipe = Recipe.create(recipe_params.merge(user: @user))
      Ingredient.find(params[:ingredients]).each { |ingredient| @recipe.ingredients << ingredient }
      if @user.first_recipe == false
        CreateFirstNotificationJob.set(wait: 3.minutes).perform_later(user: @user, recipe: @recipe)
        @user.update(first_recipe: true)
      end
      render json: @recipe, status: :created, location: @recipe
    end
  rescue ActiveRecord::TransactionIsolationError => e
    render json: e, status: :unprocessable_entity
  end

  def add_to_cart
    if (@user.id == params[:user_id]) ||
       Friendship.find_by(user: User.find(params[:user_id]), friend_id: @user.id)
      @recipe.ingredients.each do |ingredient|
        CartIngredient.create(cart_id: Cart.find_by(user_id: params[:user_id]).id,
                              ingredient_id: ingredient.id, user_id: @user.id)
      end
      render json: @recipe, location: @recipe
    else
      raise
    end
  rescue RuntimeError
    render json: { error: "You can not add recipe '#{@recipe.title}' to cart #{params[:cart_id]} " },
           status: :unprocessable_entity
  end

  # PATCH/PUT /recipes/1
  def update
    if @recipe.user == @user
      ActiveRecord::Base.transaction do
        unless params[:ingredients].nil?
          # TODO: place which somebody must rewrite because delete then create is a bad practice for update
          # @recipe.ingredients.update(params[:ingredients])
          @recipe.ingredients.clear
          Ingredient.find(params[:ingredients]).each { |ingredient| @recipe.ingredients << ingredient }
        end
        @recipe.update(recipe_params) unless recipe_params.nil?
        render json: @recipe
      end
    else
      raise
    end
  rescue ActiveRecord::TransactionIsolationError => e
    render json: e, status: :unprocessable_entity
  rescue RuntimeError
    render json: { error: "You can not update Recipe '#{@recipe.title}'" },
           status: :unprocessable_entity
  end

  # DELETE /recipes/1
  def destroy
    if @recipe.user == @user
      ActiveRecord::Base.transaction do
        @recipe.ingredients.clear
        @recipe.destroy
      end
    else
      raise
    end
  rescue ActiveRecord::TransactionIsolationError => e
    render json: e, status: :unprocessable_entity
  rescue RuntimeError
    render json: { error: "You can not destroy Recipe '#{@recipe.title}'" },
           status: :unprocessable_entity
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def recipe_params
    params[:recipe].permit(:title, :description, :image)
  end

  def search_recipes
    search_result = []
    params[:search].split.each do |search_word|
      Recipe.joins(:ingredients).references(:ingredients)
            .where("upper(ingredients.title) LIKE '%#{search_word.upcase}%'
                    OR upper(recipes.title) LIKE '%#{search_word.upcase}%'").each do |recipe|
        search_result.push recipe
      end
    end
    search_result.uniq
  end
end

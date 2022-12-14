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
      @recipe = Recipe.create(recipe_params)
      transformation(params[:ingredients]) if params[:ingredients].instance_of?(String)
      Ingredient.find(params[:ingredients]).each { |ingredient| @recipe.ingredients << ingredient }
      if @user.recipes.count == 1
        CreateFirstNotificationJob.set(wait: 2.minutes).perform_later(user: @user, recipe: @recipe)
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
          transformation(params[:ingredients]) if params[:ingredients].instance_of?(String)
          @recipe.ingredients.clear
          Ingredient.find(params[:ingredients]).each { |ingredient| @recipe.ingredients << ingredient }
        end
        @recipe.update(recipe_params.merge(updated_at: Time.now)) unless recipe_params.nil?
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
    raise unless @recipe.user == @user

    ActiveRecord::Base.transaction do
      @recipe.ingredients.clear
      @recipe.destroy
    end
  rescue ActiveRecord::TransactionIsolationError => e
    render json: e, status: :unprocessable_entity
  rescue RuntimeError
    render json: { error: "You can not destroy Recipe '#{@recipe.title}'" },
           status: :unprocessable_entity
  end

  private

  # Type conversion for ingredients "[1,2]" => [1,2]
  def transformation(ingredients)
    temp = ingredients.delete '[]'
    params[:ingredients] = temp.split(',').map(&:to_i)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def recipe_params
    {
      title: params[:title],
      description: params[:description],
      image: params[:image],
      user: @user
    }
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

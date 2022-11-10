class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[ show update destroy ]

  # GET /recipes
  def index
    @recipes = Recipe.all

    #render json: @recipes
  end

  # GET /recipes/1
  def show
    #@recipe = Recipe.find(params[:id])
    #render json: @recipe
  end

  # POST /recipes
  def create
    begin
      ActiveRecord::Base.transaction do
        unless params[:description].nil?
          params.require(:recipe)[:description_id] = Description.create(body: params[:description]).id.to_s
        else
          raise ActiveRecord::RecordInvalid
        end
        @recipe = Recipe.create(recipe_params)
        params[:ingredients].each {|id| RecipeIngredient.create(recipe_id: @recipe.id, ingredient_id: id)}
        render json: @recipe, status: :created, location: @recipe
      end
    rescue ActiveRecord::TransactionIsolationError => exception
      render json: exception, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /recipes/1
  def update
    begin
      ActiveRecord::Base.transaction do
        unless params[:description].nil?
          description = Description.find(BSON::ObjectId.from_string(@recipe.description_id))
          description.update(body: params[:description])
          params.require(:recipe)[:description_id] = description.id.to_s
        end
        # place which somebody must rewrite because delete then create is a bad practice for update
        unless params[:ingredients].nil?
          RecipeIngredient.where(recipe_id: @recipe.id).map(&:delete)
          params[:ingredients].each {|id| RecipeIngredient.create!(recipe_id: @recipe.id, ingredient_id: id)}
        end
        @recipe.update(recipe_params) unless recipe_params.nil?
        render json: @recipe
      end
    rescue ActiveRecord::TransactionIsolationError => exception
      render json: exception, status: :unprocessable_entity
    end
  end

  # DELETE /recipes/1
  def destroy
    begin
      ActiveRecord::Base.transaction do
        Description.find(BSON::ObjectId.from_string(@recipe.description_id)).delete
        RecipeIngredient.where(recipe_id: @recipe.id).map(&:delete)
        @recipe.destroy
      end
    rescue ActiveRecord::TransactionIsolationError => exception
      render json: exception, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def recipe_params
      params.require(:recipe).permit(:title, :description_id, :image, :user_id)
    end
end

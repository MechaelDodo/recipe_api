class IngredientsController < ApplicationController
  before_action :authorize
  before_action :set_ingredient, only: %i[ add_to_cart remove_from_cart ]

  def index
    @ingredient = Ingredient.all
    render json: @ingredient
  end

  def add_to_cart
    CartIngredient.create(cart_id: params[:cart_id],  #Cart.find_by(user_id: params[:user_id]).id,
                          ingredient_id: @ingredient.id, user_id: @user) #current_user.id
    render json: @ingredient, location: @ingredient
  end

  def remove_from_cart
    CartIngredient.find_by(cart_id: params[:cart_id],  #Cart.find_by(user_id: params[:user_id]).id,
                          ingredient_id: @ingredient.id, user_id: @user).delete #current_user.id
    render json: @ingredient, location: @ingredient
  end

  private

  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end

end

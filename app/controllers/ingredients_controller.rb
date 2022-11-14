# frozen_string_literal: true

class IngredientsController < ApplicationController
  before_action :authorize
  before_action :set_ingredient, only: %i[add_to_cart remove_from_cart]

  def index
    @ingredient = Ingredient.all
    render json: @ingredient
  end

  def add_to_cart
    if (@user.id == params[:user_id]) ||
       Friendship.find_by(user: User.find(params[:user_id]), friend_id: @user.id)
      CartIngredient.create(cart_id: Cart.find_by(user_id: params[:user_id]).id,
                            ingredient_id: @ingredient.id, user_id: @user.id)
    else
      raise
    end
  rescue RuntimeError
    render json: { error: "You can not add ingredient '#{@ingredient.title}' to #{User.find(params[:user_id]).username}'s cart " },
           status: :unprocessable_entity
  end

  def remove_from_cart
    cart_ingredient = CartIngredient.find_by(cart_id: Cart.find_by(user_id: params[:user_id]),
                                             ingredient_id: @ingredient.id, user_id: @user)
    if ((@user.id == params[:user_id]) ||
      Friendship.find_by(user: User.find(params[:user_id]), friend_id: @user.id)) && cart_ingredient
      cart_ingredient.delete
    else
      raise
    end
  rescue RuntimeError
    render json: { error: "You can not delete ingredient '#{@ingredient.title}' from cart #{params[:user_id]} " },
           status: :unprocessable_entity
  end

  private

  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end
end

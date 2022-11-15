# frozen_string_literal: true

# class UsersController
class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def show_friends
    @users = User.includes(:friendships).where("friendships.user_id=#{@user.id}").references(:friendships)
  end

  def add_friend
    if Friendship.find_by(user: @user, friend_id: params[:friend_id]).nil?
      Friendship.create(user: @user, friend_id: params[:friend_id])
    else
      raise
    end
  rescue RuntimeError
    render json: { error: "User #{User.find(params[:friend_id]).username} is your friend" },
           status: :unprocessable_entity
  end

  def remove_friend
    if Friendship.find_by(user: @user, friend_id: params[:friend_id]).nil?
      raise
    else
      Friendship.where(user: @user, friend_id: params[:friend_id]).destroy_all
      CartIngredient.where(user_id: params[:friend_id], cart: @user.cart).destroy_all
    end
  rescue RuntimeError
    render json: { error: "User #{User.find(params[:friend_id]).username} is not your friend" },
           status: :unprocessable_entity
  end

  def create
    ActiveRecord::Base.transaction do
      @user = User.create(users_params)
      if @user.valid?
        token = encode_token(user_id: @user.id)
        Cart.create(user: @user)
        render json: { user: @user, token: token }, status: :created
      else
        render json: { error: 'Invalid username, password or email' }, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::TransactionIsolationError => e
    render json: e, status: :unprocessable_entity
  end

  def login
    @user = User.find_by(username: users_params[:username])

    if @user&.authenticate(users_params[:password])
      token = encode_token(user_id: @user.id)
      render json: { user: @user, token: token }, status: :ok
    else
      render json: { error: 'Invalid username, password or email' }, status: :unprocessable_entity
    end
  end

  private

  def users_params
    params.require(:user).permit(:username, :email, :password)
  end
end

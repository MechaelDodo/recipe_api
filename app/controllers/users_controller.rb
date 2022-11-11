# frozen_string_literal: true

# class UsersController
class UsersController < ApplicationController
  def index
    @users = User.all

    render json: @users
  end

  def create
    @user = User.create(users_params)

    if @user.valid?
      token = encode_token(user_id: @user.id)
      render json: { user: @user, token: token }, status: :created
    else
      render json: { error: 'Invalid username, password or email' }, status: :unprocessable_entity
    end
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

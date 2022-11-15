# frozen_string_literal: true

# class UsersController
class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  def index
    @users = User.all

    render json: @users
  end

  def show; end

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

  def update
    if @user.update(users_params)
      render :show, status: :ok, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def users_params
    params.require(:user).permit(:username, :email, :password)
  end
end

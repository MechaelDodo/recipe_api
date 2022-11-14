# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :authorize

  def show
    @cart = User.find(params[:id]).cart
  end
end

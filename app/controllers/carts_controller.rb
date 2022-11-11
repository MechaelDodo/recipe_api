# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :authorize

  def show
    @cart = Cart.find(params[:id])
  end
end

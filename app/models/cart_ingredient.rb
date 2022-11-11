# frozen_string_literal: true

class CartIngredient < ApplicationRecord
  belongs_to :cart
  belongs_to :ingredient
end

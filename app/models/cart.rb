# frozen_string_literal: true

class Cart < ApplicationRecord
  has_many :cart_ingredients
  has_many :ingredients, through: :cart_ingredients
  belongs_to :user
end

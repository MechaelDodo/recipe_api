class Cart < ApplicationRecord
  has_many :cart_ingredients
  has_many :ingredients, through: :cart_ingredients
end

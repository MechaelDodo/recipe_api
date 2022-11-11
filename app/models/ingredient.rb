class Ingredient < ApplicationRecord
  has_and_belongs_to_many :recipes
  has_many :cart_ingredients
  has_many :carts, through: :cart_ingredients
end

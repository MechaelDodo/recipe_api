class CartIngredient < ApplicationRecord
  belongs_to :cart
  belongs_to :ingredient
end

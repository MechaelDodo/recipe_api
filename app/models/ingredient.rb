class Ingredient < ApplicationRecord
  has_and_belongs_to_many :recipes

  #has_many :recipes, through: :recipe_ingredients
end

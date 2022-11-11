# frozen_string_literal: true

# filling Recipe and Ingredient
5.times do
  @recipe = Recipe.create(title: Faker::Food.dish,
                          description: Faker::Food.description,
                          image: Faker::LoremFlickr.image,
                          user_id: 1)
  @ingredient = Ingredient.create(title: Faker::Food.ingredient)
end

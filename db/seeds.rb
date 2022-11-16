# frozen_string_literal: true

# create user
@user = User.create(username: 'Anton', email: 'tes4t@gmail.com', password: '123123')

# create the cart for user
@cart = Cart.create(user: @user)

# one ingredient to check the search
@ingredient = Ingredient.create(title: 'Cucumber')

# filling other ingredients
5.times do
  @ingredient = Ingredient.create(title: Faker::Food.ingredient)
end

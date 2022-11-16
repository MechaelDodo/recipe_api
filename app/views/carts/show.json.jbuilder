# frozen_string_literal: true

json.cart_id @cart.id
json.user @cart.user, :id, :username

# TODO: json.ingredients CartIngredient.includes(:cart).group_by(&:user_id).each_key do |user_id|
# TODO: посмотри в users_controller show_friends, там возможно подсказка
json.ingredients CartIngredient.where(cart_id: @cart.id).group_by(&:user_id).each_key do |user_id|
  json.user User.find(user_id), :id, :username
  json.ingredients CartIngredient.where(cart_id: @cart.id,
                                        user_id: user_id).group_by(&:ingredient_id).each do |ingredient_arr|
    json.ingredient_id ingredient_arr[0]
    json.title Ingredient.find(ingredient_arr[0]).title
    json.count ingredient_arr[1].count
  end
end

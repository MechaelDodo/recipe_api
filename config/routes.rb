# frozen_string_literal: true

Rails.application.routes.draw do
  resources :recipes
  post '/recipes/add_to_cart/', to: 'recipes#add_to_cart'
  resources :carts
  resources :ingredients
  post '/ingredients/add_to_cart/', to: 'ingredients#add_to_cart'
  post '/ingredients/remove_from_cart/', to: 'ingredients#remove_from_cart'

  resources :users
  post '/login', to: 'users#login'
end

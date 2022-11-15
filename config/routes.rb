# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do

  mount Sidekiq::Web => '/sidekiq'
  resources :recipes
  post '/recipes/add_to_cart/', to: 'recipes#add_to_cart'
  resources :carts
  resources :ingredients
  post '/ingredients/add_to_cart/', to: 'ingredients#add_to_cart'
  post '/ingredients/remove_from_cart/', to: 'ingredients#remove_from_cart'

  resources :users
  post '/login', to: 'users#login'
  post '/add_friend', to: 'users#add_friend'
  post '/remove_friend', to: 'users#remove_friend'
  get '/show_friends', to: 'users#show_friends'
end

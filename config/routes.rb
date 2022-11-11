# frozen_string_literal: true

Rails.application.routes.draw do
  resources :recipes

  resources :users
  post '/login', to: 'users#login'
end

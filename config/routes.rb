Rails.application.routes.draw do
  resources :recipes
  post "/recipes/add_to_cart/", to: 'recipes#add_to_cart'
  resources :carts
  resources :ingredients
  post "/ingredients/add_to_cart/", to: 'ingredients#add_to_cart'
  post "/ingredients/remove_from_cart/", to: 'ingredients#remove_from_cart'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

Rails.application.routes.draw do

  root to: 'pages#index'
  
  get "/check_user", to: "users#check", as: :check_user
  get "/cabinet", to: "sessions#current_user_page", as: :my
  get "/signin", to: "sessions#new", as: :signin
  post "/signin", to: "sessions#new"
  get "/signout", to: "sessions#destroy", as: :signout
  get "/signup", to: "users#new", as: :signup
  resources :sessions, only: [:new, :create, :destroy]
  resources :boat_parameter_values
  resources :boat_parameter_types
  resources :boat_types
  resources :users
  
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

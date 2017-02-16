Rails.application.routes.draw do

  resources :boat_series
  resources :trademarks
  root to: 'pages#index'
  
  get "/check_user", to: "users#check", as: :check_user
  get "/cabinet", to: "sessions#current_user_page", as: :my
  get "/signin", to: "sessions#new", as: :signin
  post "/signin", to: "sessions#new"
  get "/signout", to: "sessions#destroy", as: :signout
  get "/signup", to: "users#new", as: :signup
  
  resources :sessions, only: [:new, :create]
  
  resources :boat_parameter_values, only: [:update]
  get "/boat_parameter_values/:id/:boat_type_id", to: "boat_parameter_values#switch_bind"
  resources :boat_parameter_types, only: [:new, :create, :destroy, :edit, :update, :index]
  post "/reorder_boat_parameter_types", to: "boat_parameter_types#update_numbers"
  get "/reorder_boat_parameter_types", to: "boat_parameter_types#update_numbers"
  
  resources :boat_types
  get "/manage_boat_types", to: "boat_types#manage_index", as: :manage_boat_types
  resources :users
  
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

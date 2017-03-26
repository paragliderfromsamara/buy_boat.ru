Rails.application.routes.draw do
  #boat_for_sales
  resources :boat_for_sales
  post "/parse_selected_options_file", to: "boat_for_sales#parse_selected_options_file"
  get "/parse_selected_options_file", to: "boat_for_sales#parse_selected_options_file"
  get "/manage_boat_for_sale", to: "boat_for_sales#manage_index", as: :manage_boat_for_sales
  #end
  resources :boat_option_types, only: [:index, :show, :update]

  get "/test_page", to: "pages#test_page"
  
  resources :boat_series
  resources :trademarks
  root to: 'pages#index'
  
  
  get "/check_user", to: "users#check", as: :check_user
  get "/cabinet", to: "sessions#current_user_page", as: :my
  get "/signin", to: "sessions#new", as: :signin
  post "/signin", to: "sessions#new"
  get "/signout", to: "sessions#destroy", as: :signout
  get "/signup", to: "users#new", as: :signup
  
  #get "/boat_types_import", to: "pages#boat_type_import"
  
  
  resources :sessions, only: [:new, :create]
  
  resources :boat_parameter_values, only: [:update]
  get "/boat_parameter_values/:id/:boat_type_id", to: "boat_parameter_values#switch_bind", as: :switch_bind_parameter_value #привязка-отвязка атрибутов от лодки
  resources :boat_parameter_types, only: [:new, :create, :destroy, :edit, :update, :index]
  post "/reorder_boat_parameter_types", to: "boat_parameter_types#update_numbers"
  
  resources :boat_types
  post '/boat_types/:id/add_configurator_entity', to: "boat_types#add_configurator_entity"  
  get "/manage_boat_types", to: "boat_types#manage_index", as: :manage_boat_types
  get '/boat_types/:id/photos', to: "boat_types#photos", as: :boat_photos
  get '/boat_types/:id/photos/:photo_id', to: "boat_types#photo", as: :boat_photo
  delete '/boat_types/:id/photos/:photo_id', to: "boat_types#delete_photo"
  resources :users
  
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

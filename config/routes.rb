Rails.application.routes.draw do


  get 'shop_pages/index'

  get 'shop_pages/boats'

  get 'shop_pages/shops'

  get 'photo/show'

  get 'photo/destroy'

  resources :property_types
  #products
  resources :products
  get "/manage_products", to: "products#manage_index", as: :manage_products
  #product_types
  resources :product_types
  get "/manage_product_types", to: "product_types#manage_index", as: :manage_product_types
  #boat_type_modifications
  resources :boat_type_modifications, only: [:edit, :update]
  #user_requests
  resources :user_requests
  get "my_boats", to: "user_requests#my_requests", as: :my_boats #мои лодки 
  #shops
  resources :shops
  get "/manage_shops/:id", to: "shops#manage_show", as: :manage_shop                #страница управления магазином
  get "/manage_shops", to: "shops#manage_index", as: :manage_shops                  #управление магазинами
  get "/change_shop_status/:id", to: "shops#change_status", as: :change_shop_status #изменение статуса
  get "/manage_shops/:id/boats_for_sale", to: "shops#boats_for_sale", as: :manage_bfs_in_shop #управление лодками в магазине
  get "/manage_shops/:id/product_types/:product_type_id", to: "shops#manage_shop_products", as: :manage_shop_products #управление товарами магазине
  get "/shops/:id/product_types/:product_type_id", to: "shops#shop_products"
  resources :shop_products, only: [:update, :destroy, :create]
  get "/shops/:shop_id/products/:product_id", to: "shop_products#show", as: :in_shop_product
  
  #shop_products
  


  #end
  #locations
  get "/locations/regions/:country_id", to: "locations#regions"
  get "/locations/cities/:region_id", to: "locations#cities"
  get "/add_country", to: "locations#add_country"
  post "/add_country", to: "locations#add_country"
  #end
  #boat_for_sales
  resources :boat_for_sales
  post "/parse_selected_options_file", to: "boat_for_sales#parse_selected_options_file"
  get "/parse_selected_options_file", to: "boat_for_sales#parse_selected_options_file"
  get "/manage_boat_for_sale", to: "boat_for_sales#manage_index", as: :manage_boat_for_sales
  get "/boat_for_sales/:id/switch_favorites", to: "boat_for_sales#switch_favorites"
  get "/favorites", to: "boat_for_sales#favorites"
  get "/boat_for_sales/:id/buy", to: "boat_for_sales#buy", as: :buy_bfs
  #end
  #boat_option_types
  resources :boat_option_types, only: [:index, :show, :update]
  #end
  #photos
  resources :photos, only: [:show, :destroy]
  post '/upload_photo/:entity/:entity_id', to: 'photos#upload'
  get "/entity_photos/:entity/:entity_id", to: 'photos#entity_photos'
  put "/entity_photos/:id", to: 'photos#update_entity_photo'
  delete "/entity_photos/:id", to: "photos#destroy_entity_photo" #удаляем ссылки на фотографию от boat_type или product (удаление фотографии)
  #end
  get "/test_page", to: "pages#test_page"
  get "/about", to: "pages#about", as: :about
  get "/boats/:id", to: "pages#boat", as: :tm_site_boat
  
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
  
  resources :boat_types, only: [:create, :edit, :update, :destroy, :show]
  post '/boat_types/:id/add_configurator_entity', to: "boat_types#add_configurator_entity"  
  get "/manage_boat_types", to: "boat_types#manage_index", as: :manage_boat_types
  get '/boat_types/:id/photos', to: "boat_types#photos", as: :boat_photos
  get '/boat_types/:id/photos/:photo_id', to: "boat_types#photo", as: :boat_photo
  get '/boat_types/:id/property_values', to: 'boat_types#property_values'
  get '/boat_types/:id/modifications/:modification_id', to: 'boat_types#modification_show', as: :modification
  put '/boat_types/:id/property_values', to: 'boat_types#update_property_values'
  post '/boat_types/:id/modifications', to: 'boat_types#create_modification'
  resources :users
  
  resources :boat_property_types, only: [:index, :create] 
  
  #Realcraft Part--------------------------------------------------------------------------------------
  #get 'about', to: 'realcraft#about', as: :about
  #get "prices", to: "pages#prices", as: :prices
  get "dealers", to: "realcraft_pages#dealers", as: :realcraft_dealers
  get 'realcraft190', to: 'realcraft_pages#realcraft_190', as: :realcraft_190
  get 'realcraft200', to: 'realcraft_pages#realcraft_200', as: :realcraft_200
  get "wait", to: 'realcraft_pages#please_wait', as: :realcraft_wait
  get "about_realcraft", to: 'realcraft_pages#about', as: :realcraft_about
  post "send_boat_request", to: 'realcraft_pages#send_boat_request', as: :realcraft_send_boat_request
  post "send_dealer_request", to: 'realcraft_pages#send_dealer_request', as: :realcraft_send_dealer_request
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

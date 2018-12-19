Rails.application.routes.draw do
  resources :enquiries
  resources :reviews
  resources :pets
  get 'rooms/search_room'
  get 'rooms/find_by_cities'
  get 'rooms/authorize'
  get 'rooms/my_rooms'
  get 'rooms/find_by_cities'
  get 'rooms/by_price_asc'
  get 'rooms/by_price_desc'

  resources :rooms do 
    post 'authorize'
    post 'my_rooms'
  end
  resources :amenity_rooms
  resources :amenities
  resources :cities
  resources :roles
  devise_for :users
  resources :special_prices
  resources :reviews
  
  get 'bookings/confirmation'
  get 'bookings/my_bookings'
  match '/send_data' => 'bookings#send_data',via: :get, :as => :cashfree_payment
  resources :bookings do
   post 'confirmation'
   post 'my_bookings'
  end

  get 'payments/index'
  # resources :payments
  match '/request' => 'payments#cf_Request', via: :post
  # match '/response' => 'payments#cf_Response', via: :post
  match '/response/:user_id/:order_id' => 'payments#cf_Response', via: [:get, :post, :put, :patch, :delete]

  root 'rooms#index'
end

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
  get '/get_all_cities', :to => 'rooms#get_all_cities' 
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
  get '/paytm_payment' => 'bookings#paytm_payment', :as => :paytm_payment
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
  match '/choose_payment' => 'payments#choose_payment',via: [:get, :post, :put, :patch, :delete] ,:as => :choose_payment
  match '/redirect_payment_page' => 'payments#redirect_payment_page',via: [:get, :post, :put, :patch, :delete] ,:as => :redirect_payment_page
  match '/paytm_response' => 'payments#paytm_response',via: [:get, :post, :put, :patch, :delete] ,:as => :paytm_response
  match '/paytm_request' => 'payments#paytm_request',via: [:get, :post, :put, :patch, :delete] ,:as => :paytm_request

  root 'rooms#index'
end

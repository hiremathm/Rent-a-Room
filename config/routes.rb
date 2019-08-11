Rails.application.routes.draw do
  
  use_doorkeeper
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  resources :enquiries
  resources :reviews
  resources :pets
  resources :amenity_rooms
  resources :amenities
  resources :cities
  resources :roles
  resources :special_prices
  resources :reviews


  #Room Routes
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
  
  #Booking Routes
  get 'bookings/confirmation'
  get 'bookings/my_bookings'
  resources :bookings do
    post 'confirmation'
    post 'my_bookings'
  end

  #Payment Routes
  get 'payments/index'
  # resources :payments
  match '/request' => 'payments#cf_Request', via: :post
  # match '/response' => 'payments#cf_Response', via: :post
  match '/response/:user_id/:order_id' => 'payments#cf_Response', via: [:get, :post, :put, :patch, :delete]
  match '/choose_payment' => 'payments#choose_payment',via: [:get, :post, :put, :patch, :delete] ,:as => :choose_payment
  match '/redirect_payment_page' => 'payments#redirect_payment_page',via: [:get, :post, :put, :patch, :delete] ,:as => :redirect_payment_page
  match '/paytm_response' => 'payments#paytm_response',via: [:get, :post, :put, :patch, :delete] ,:as => :paytm_response
  match '/paytm_request' => 'payments#paytm_request',via: [:get, :post, :put, :patch, :delete] ,:as => :paytm_request
  get '/paytm_payment' => 'bookings#paytm_payment', :as => :paytm_payment
  match '/send_data' => 'bookings#send_data',via: :get, :as => :cashfree_payment

  #Externals API's
  namespace :api do 
    namespace :v1, :defaults => { :format => 'json' } do 
      #Room API Routes
      get '/rooms/rooms_by_user_id' => "rooms#find_rooms_by_user_id"
      get '/rooms/unauthorized_rooms' => "rooms#find_unauthorized_rooms"
      get '/rooms/authorized_rooms' => "rooms#find_authorized_rooms"  
      get '/rooms/authorized_rooms_for_you' => "rooms#find_authorized_rooms_by_user_id"
      get '/rooms/unauthorized_rooms_for_you' => "rooms#find_unauthorized_rooms_by_user_id"
      resources :rooms

      #Cities API Routes
      resources :cities   
      
      #User API Routes 
      post '/users/sign_in' => 'users#sign_in'
      post '/users/sign_out' => 'users#sign_out'
      post '/users/sign_up' => 'users#sign_up'

      #Booking API Routes
      get '/bookings/bookings_by_for_you' => "bookings#find_bookings_by_user_id"
      get '/bookings/all_confirmed_bookings' => "bookings#get_all_confirmed_bookings_by_user_id"
      get '/bookings/all_notconfirmed_bookings' => "bookings#get_all_notconfirmed_bookings_by_user_id"
      resources :bookings
    end
  end
  root 'rooms#index'
end
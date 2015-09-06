Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'

  get '/home', to: "videos#index"

  get '/register', to: 'users#new'
  resources :users, only: [:show, :create]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get '/sent_email_reset', to: 'forgot_passwords#sent_email_reset'

  resources :reset_passwords, only: [:show, :update]
  get '/expired_reset_link', to: 'reset_passwords#invalid_token'

  get '/my_queue', to: 'queue_items#index'
  post '/update_queue', to: 'queue_items#update_queue'
  resources :queue_items, only: [:create, :destroy]

  resources :relationships, only: [:create, :destroy]
  get '/people', to: 'relationships#index'

  resources :videos, only: [:index, :show] do
    collection do
      get 'search', to: "videos#search"
    end
    resources :reviews, only: [:create]
  end

  resources :categories, only: [:show]
end

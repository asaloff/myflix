Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'

  get '/home', to: "videos#index"
  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  resources :users, only: [:create]

  resources :videos, only: [:index, :show] do
    collection do
      get 'search', to: "videos#search"
    end
    resources :reviews, only: [:create]
  end
  resources :categories, only: [:show]
end

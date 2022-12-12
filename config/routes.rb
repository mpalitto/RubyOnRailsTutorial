Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'sessions#login'
  
  #root 'pages#home'
  get '/home', to:  'pages#home'
  # User routes
  resources :users, only: [:new, :create, :edit, :update, :show, :destroy]
  # Session routes
  get '/login', to: 'sessions#login'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  post '/logout', to: 'sessions#destroy'
  get '/waiting4approval', to: 'sessions#waiting4approval'
  get '/riattiva', to: 'sessions#riattiva'
  get '/utenti', to: 'users#list'
  get '/history', to: 'users#showHistory'
  get '/commenti', to: 'users#showCommenti'
  post '/saveCommenti', to: 'users#saveCommenti'

  resource :tasks do
    get 'filter_apt', on: :member
    get 'clear', on: :member
    get 'history', on: :member
    get 'view', on: :member
    get 'commenti', on: :member
    post 'saveCommenti', on: :member
  end
  resources :tasks,  except:  [:index, :show] 
  resources :stati_richiesta,  except:  [:index, :show] 

end

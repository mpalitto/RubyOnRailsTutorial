Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'pages#home'
  resource :tasks, only: [] do
    get 'clear', on: :member
  end
  resources :tasks,  except:  [:index, :show] 

end

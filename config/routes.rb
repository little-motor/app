Rails.application.routes.draw do
  root 'static_pages#home'  #得到root_url辅助方法
 
  get '/about', to:'static_pages#about'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create' #登陆

  delete '/logout', to: 'sessions#destroy'
  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/about'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users  #资源名，用来让rails完成REST框架的各个规定动作，直接指向index
  resources :account_activations,only: [:edit]
  resources :microposts, only: [:create,:destroy]
end

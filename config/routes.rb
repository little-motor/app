Rails.application.routes.draw do
  root 'static_pages#home'  
 
  #static_pages_controller
  get '/about', to:'static_pages#about'
  get '/help', to:'static_pages#help'
  get '/home', to:'static_pages#home'

  #users_controllers
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  #sessions_controllers
  #得到登录账号密码表单
  get '/login', to: 'sessions#new'
  #向服务器发送账号和密码
  post '/login', to: 'sessions#create' 
  delete '/logout', to: 'sessions#destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #资源名，用来让rails完成REST框架的各个规定动作，直接指向index
  resources :users  
  resources :account_activations,only: [:edit]
  resources :microposts, only: [:create,:destroy]
 
end

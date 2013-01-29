Yumster::Application.routes.draw do

  root :to => 'pages#home'
  #root :to => 'locations#index'

  resources :locations, :only => [:index, :new, :create, :show]

  get "pages/home"

end

Yumster::Application.routes.draw do

  devise_for :users
  #devise_for :users, :path_prefix => 'd'
  #resources :users, :only => [:show]
  match 'users/:username' => 'users#show'

  root :to => 'pages#home'

  resources :locations, :only => [:index, :new, :create, :show] do
    collection do
      get 'near'
    end
  end

  get "pages/home"

end

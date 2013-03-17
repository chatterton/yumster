Yumster::Application.routes.draw do

  get "admin/locations"

  devise_for :users
  get 'users/:username' => 'users#show', :as => 'user'

  root :to => 'pages#home'

  resources :locations, :only => [:new, :create, :show] do
    collection do
      get 'near'
    end
  end

  get "pages/home"
  get "pages/about"

  resources :tips, :only => [:create, :destroy]

end

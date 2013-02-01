Yumster::Application.routes.draw do

  root :to => 'pages#home'

  resources :locations, :only => [:index, :new, :create, :show] do
    collection do
      get 'near'
    end
  end

  get "pages/home"

end

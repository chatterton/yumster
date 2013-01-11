Yumster::Application.routes.draw do

  root :to => 'locations#index'

  resources :locations, :only => [:index, :new, :create, :show]

end

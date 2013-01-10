Yumster::Application.routes.draw do

  root :to => 'locations#index'

  get "locations/index"

  get "locations/new"

end

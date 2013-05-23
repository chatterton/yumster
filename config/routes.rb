Yumster::Application.routes.draw do

  # This line mounts Forem's routes at /forums by default.
  # This means, any requests to the /forums URL of your application will go to Forem::ForumsController#index.
  # If you would like to change where this extension is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Forem relies on it being the default of "forem"
  mount Forem::Engine, :at => '/f'


  get "admin/locations"
  put "admin/locations/:id/approve" => "admin#approve", :as => "approve_location"
  get "admin/home"
  get "admin/" => "admin#home"
  get "admin/users"
  get "admin/all_locations"

  devise_for :users
  get 'users/:username' => 'users#show', :as => 'user'

  root :to => 'pages#home'

  resources :locations, :only => [:new, :create, :show, :update] do
    collection do
      get 'near'
    end
  end

  get "pages/home"
  get "pages/about"

  resources :tips, :only => [:create, :destroy]

end

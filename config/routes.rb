YahmsNetDevelopment::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'


  match 'api/c/:mac/:version/:timestamp' => 'api#conf', :as => :api_config, :format => :text
  match 'api/s/:mac/:version' => 'api#submit', :as => :api_submit
  resource :account, :controller => "users"
  resources :users
  resources :systems
  resources :base_stations
  resources :analog_inputs
  resources :digital_outputs
  resources :digital_outputs do
    
    member do
      put :advance
      put :plus_time
    end
  
  end

  resources :systems do
  
    member do
      put :revoke_access
      put :grant_access
    end
    
  end

  resource :user_session
  match '/' => 'user_sessions#new'
  match '/logout' => 'user_sessions#destroy', :as => :logout
  match '/mf' => 'user_sessions#makerfaire'
end

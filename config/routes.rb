ActionController::Routing::Routes.draw do |map|

  # API Keys for developer access
  # map.resources :api_key
  
  # Pilot flight log resources
  map.resource :pilots, :as => 'pilot' do |pilot|
    pilot.resource :preferences
    pilot.resources :statistics
    pilot.resources :log_entry, :as => 'log', :collection => { :export => :get }
    pilot.resources :locations    
    pilot.resources :equipment, :member => { :restore => :post }
    pilot.settings 'settings', :controller => 'pilots', :action => 'settings'
    pilot.resource :pilot_licenses, :as => 'settings/licenses'
    pilot.resources :license
  end
  
  # Restful Authentication Resources
  map.resources :users, :except => [:show]
  map.resources :passwords, :except => [:show, :index]
  map.resource :session, :except => [:show, :index]
  
  map.resources :assets
    
  # Restful Authentication Rewrites
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
  map.open_id_complete '/opensession', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  map.open_id_create '/opencreate', :controller => "users", :action => "create", :requirements => { :method => :get }
  
  # Home Page
  map.root :controller => 'sessions', :action => 'new'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

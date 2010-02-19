ActionController::Routing::Routes.draw do |map|


  map.resources :wish_lists, :collection => {:add_to_wishlist => :get,:publish_to_friends => :any,:remove_category => :any}

  map.resources :emails

  map.resources :plans
  
  map.resources :fb_categories
  map.resource :account, :controller => "users"
  map.resources :users
  map.resource :user_session, :member => {:logout => :get}
  map.resource :admin,      :member => {:user_list => :get,:index => :get}
  #map.resources :user_sessions

  #map.resources :users

  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"

   map.namespace(:admin) do |admin|
    admin.resources :users, :controller => 'users'
    admin.resources :categories, :controller => 'categories',:collection => {:subcategory_new => :get}
   end

  map.resources :categories, :collection => {:subcategory_new => :get}
  map.root :controller => "dashboards", :action => "index"
end

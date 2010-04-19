ActionController::Routing::Routes.draw do |map|
  map.resources :measurements
  map.resources :subscriptions
  
  map.dropbox ':gate_name.:format', :controller => 'gates', :action => 'receive',
              :conditions => {:method => :post}
                
  map.queue ':gate_name/pop.:format', :controller => 'gates', :action => 'retrieve', 
              :conditions => {:method => :get}
end

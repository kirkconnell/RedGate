ActionController::Routing::Routes.draw do |map|
  map.resources :measurements
  
  map.queue ':gate_name', :controller => 'gates', :action => 'retrieve', 
              :conditions => {:method => :get}
           
  map.dropbox ':gate_name.:format', :controller => 'gates', :action => 'receive',
              :conditions => {:method => :post}

end

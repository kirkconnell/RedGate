ActionController::Routing::Routes.draw do |map|
  
  map.gate 'gates/:gate_name', :controller => 'gates', :action => 'retrieve', 
              :conditions => {:method => :get}
           
  map.dropbox 'gates/:gate_name', :controller => 'gates', :action => 'receive',
              :conditions => {:method => :post}

end

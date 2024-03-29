ActionController::Routing::Routes.draw do |map|
  #UJS::routes
  # ActiveRbac's RegistrationController confirmation action needs a special route
  map.connect '/active_rbac/registration/confirm/:user/:token', 
            :controller => 'active_rbac/registration', 
            :action => 'confirm'

  map.connect '', :controller => "space", :action => "show_month", :id=>nil
            
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect '/sitemap.xml', :controller=>'space', :action => 'sitemap'
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  map.display_page 'display/:space_name/:page_title', :controller=>'page', :action=>'displaypage'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect 'jspwiki/pages/viewblog', :controller=>'page', :action=>'show'
  map.connect 'jspwiki/pages/viewwiki', :controller=>'page', :action=>'show'
  map.connect 'jspwiki/pages/:action/:id', :controller=>'page'
  map.connect 'jspwiki/:controller/:action/:id'
end

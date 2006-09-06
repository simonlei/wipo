ActionController::Routing::Routes.draw do |map|
  # ActiveRbac's RegistrationController confirmation action needs a special route
  map.connect '/active_rbac/registration/confirm/:user/:token', 
            :controller => 'active_rbac/registration', 
            :action => 'confirm'

#  map.connect '', :controller => "main", :action => "welcome"
            
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.

  # --- START OF WIKI ROUTES ---
  map.connect  '', :controller => "books", :action => "premiere"

  map.home     ':book_url_name', :controller => "pages", :action => "show", :page_title => "Home Page"
  map.pages    ':book_url_name/pages', :controller => "pages", :action => "index"
  map.recent   ':book_url_name/recent', :controller => "pages", :action => "recent"
  map.page     ':book_url_name/pages/:page_title', :controller => "pages", :action => "show"
  map.new      ':book_url_name/pages/:page_title/versions/new', :controller => "versions", :action => "new"
  map.rollback ':book_url_name/pages/:page_title/versions/new/:version_number', :controller => "versions", :action => "new", :requirements => { :version_number => /^\d+$/ }
  map.version  ':book_url_name/pages/:page_title/versions/:version_number', :controller => "versions", :action => "show", :requirements => { :version_number => /^\d+$/ }
               
  map.connect  ':book_url_name/pages/:page_title/:controller/:action/:id'

  map.feed     ':book_url_name/feed.rss', :controller => "books", :action => "feed"

  # Backwards compatible URLs with Instiki
  map.connect  ':book_url_name/show/:page_title',   :controller => "alias", :action => "show"
  map.connect  ':book_url_name/rss_with_content',   :controller => "alias", :action => "feed"
  map.connect  ':book_url_name/rss_with_headlines', :controller => "alias", :action => "feed"

  map.connect  ':book_url_name/:controller/:action/:id'      
  # --- END OF WIKI ROUTES ---

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end

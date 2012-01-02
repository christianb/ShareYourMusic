Projekt::Application.routes.draw do
    
    
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
    #match "user/:id" => 'user#show'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  
  # Sample resource route (maps HTTP verbs to controller actions automatically):
  
    devise_for :users
    
    match '/search' => 'application#search', :as => :search
  
  match '/autoCompl' => 'application#autoCompl', :as => :autoCompl
  
  scope "(:locale)", :locale => /de|en/ do
    root :to => 'welcome#index', :as => :welcome
    
    resources :user, :except => [:show, :destroy]
    match '/user/most_active' => 'user#most_active', :as => :most_active_user
    match 'user/reset_password' => 'user#reset_password', :as => :reset_password
    match '/user/setAdmin/:id' => 'user#set_as_admin', :as => :set_as_admin, :via => :get
    match '/user/setUser/:id' => 'user#set_as_user', :as => :set_as_user, :via => :get
    match '/user/:id' => 'user#show', :as => :user, :via => :get
    match '/user/:id' => 'user#destroy', :as => :delete_user, :via => :delete
   
    
    resources :devise
    
    resources :compact_disk, :except => [:show, :destroy]
    match '/compact_disk/latest' => 'compact_disk#latest', :as => :latest_cd
    match 'compact_disk/like/:id' => 'compact_disk#like', :as => :like_cd, :via => :get
    match 'comapct_disk/best' => 'compact_disk#best', :as => :best_cd, :via => :get
    match '/compact_disk/:id' => 'compact_disk#show', :as => :compact_disk, :via => :get
    match '/compact_disk/myCDs/:id' => 'compact_disk#myCDs', :as => :myCDs
    match 'compact_disk/swap/:id' => 'compact_disk#swap', :as => :swap_cd
    match '/compact_disk/all_user_cds/:id' => 'compact_disk#all_user_cds', :as => :allUserCDs
    match 'compact_disk/makeVisible/:id' => 'compact_disk#makeVisible', :as => :makeVisible
    match 'compact_disk/:id' => 'compact_disk#destroy', :as => :delete_cd, :via => :delete
    
    
    resources :transaction
    match 'transaction/destroy/:id' => 'transaction#destroy', :as => :destroy
    match 'transaction/rejected/:id' => 'transaction#rejected', :as => :rejected
    match 'transaction/accept/:id' => 'transaction#accept', :as => :accept
    match 'transaction/accepted/:id' => 'transaction#accepted', :as => :accepted
    match 'transaction/modifyAccept/:id' => 'transaction#modifyAccept', :as => :modified_accept
    match 'transaction/modifyAccepted/:id' => 'transaction#modifyAccepted', :as => :modify_accepted
    match 'transaction/modifyReject/:id' => 'transaction#modifyReject', :as => :modified_reject
    match 'transaction/modifyRejected/:id' => 'transaction#modifyRejected', :as => :modified_rejected
    match 'transaction/modify/:id' => 'transaction#modify', :as => :modify, :via => :post
    match 'transaction/modifyRequest/:id' => 'transaction#modifyRequest', :as => :modifyRequest
    
    
    
    match 'impressum' => "application#impressum", :as => :impressum
    match 'admin/manage_users' => 'admin#manage_users', :as => :adminAllUsers
    match 'admin/manage_cds' => 'admin#manage_cds', :as => :adminAllCDs
    #match '/compact_disk' => 'compact_disk#index', :as => :compact_disk_index
    #match '/compact_disk/new' => 'compact_disk#new', :as => :new_compact_disk
  end
  
  #match "user_root" => "user#show"
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
  

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

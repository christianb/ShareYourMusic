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
  
  
  
  
  #scope "(:locale)", :locale => /de|en/ do
    root :to => 'welcome#index', :as => :welcome
    
    resources :user
    resources :devise
    
    resources :compact_disk, :except => :show
    match '/compact_disk/latest' => 'compact_disk#latest', :as => :latest_cd
    match '/compact_disk/:id' => 'compact_disk#show', :as => :compact_disk
    
    match '/compact_disk/myCDs/:id' => 'compact_disk#myCDs', :as => :myCDs
    match 'compact_disk/swap/:id' => 'compact_disk#swap', :as => :swap_cd
    match '/compact_disk/all_user_cds/:id' => 'compact_disk#all_user_cds', :as => :allUserCDs
    
    resources :transaction
    match 'transaction/destroy/:id' => 'transaction#destroy', :as => :destroy
    match 'transaction/rejected/:id' => 'transaction#rejected', :as => :rejected
    match 'transaction/accept/:id' => 'transaction#accept', :as => :accept
    match 'transaction/accepted/:id' => 'transaction#accepted', :as => :accepted
    match 'transaction/modifyAccept/:id' => 'transaction#modifyAccept', :as => :modified_accept
    match 'transaction/modifyAccepted/:id' => 'transaction#modifyAccepted', :as => :modify_accepted
    match 'transaction/modifyReject/:id' => 'transaction#modifyReject', :as => :modified_reject
    match 'transaction/modifyRejected/:id' => 'transaction#modifyRejected', :as => :modified_rejected
    match 'transaction/modify/:id' => 'transaction#modify', :as => :modify
    match 'transaction/modifyRequest/:id' => 'transaction#modifyRequest', :as => :modifyRequest
    
    
    match 'user/reset_password' => 'user#reset_password', :as => :reset_password
    
    match 'admin/show_all_users' => 'admin#show_all_users', :as => :adminAllUsers
    #match '/compact_disk' => 'compact_disk#index', :as => :compact_disk_index
    #match '/compact_disk/new' => 'compact_disk#new', :as => :new_compact_disk
  #end
  
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

Esquire::Application.routes.draw do
  
  resources :users
  resources :sessions, :only => [:new, :create, :destroy]
  resources :articles, :only => [:new, :create, :index, :show, :edit, :update]
  resources :expenses, :only => [:new, :create, :index, :edit, :update, :destroy]
  resources :magzines, :only => [:index, :show, :stats]
  resources :contacts, :only => [:index, :show, :new, :create, :destroy, :edit, :update]
  resources :messages, :only => [:index, :destroy, :read, :create, :unread_count, :mark_read]
  
  match '/about', :to => 'pages#about'
  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  match '/profile', :to => 'users#show'
  match '/edit', :to => 'users#edit'
  match '/user/edit/:id', :to => "users#edit"
  match '/user/authorize/:id', :to=> 'users#update'
  match '/user/delete/:id', :to=> 'users#destroy'
  match '/article/edit/:id', :to=>'articles#edit'
  match '/article/update/:id', :to=>'articles#update'
  match '/expense/new/:exp_type/:article_id', :to=>'expenses#new'
  match '/expenses/:article_id', :to=>'expenses#index'
  match '/expense/edit/:id', :to=>'expenses#edit'
  match '/expense/delete/:id', :to=>'expenses#destroy'
  match '/expenses/excel/:no', :to=>'magzines#export_excel'
  match '/magzine/:no', :to=>'magzines#show'
  match '/stats', :to=>'magzines#stats'
  match '/contact/delete/:id', :to=>'contacts#destroy'
  match '/contact/edit/:id', :to=>'contacts#edit'
  match '/contact/show', :to=>'contacts#show'
  match '/messages/:box', :to=>'messages#index'
  match '/message/delete/:id/:box', :to=>'messages#destroy'
  match '/unread_count', :to=>'messages#unread_count'
  match '/mark_read', :to=>'messages#mark_read'

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
  root :to => 'pages#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

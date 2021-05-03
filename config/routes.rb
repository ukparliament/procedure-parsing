Rails.application.routes.draw do
  get 'home/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  
  get 'procedures' => 'procedure#index', as: :procedure_list
  get 'procedures/:procedure' => 'procedure#show', as: :procedure_show
  get 'procedures/:procedure/work-packages' => 'procedure#work_package_index', as: :procedure_work_package_list
  get 'procedures/:procedure/routes' => 'procedure#route_index', as: :procedure_route_list
  post 'procedures/:procedure/routes/create' => 'procedure#route_create', as: :procedure_route_create
  
  get 'work-packages/:work_package' => 'work_package#show', as: :work_package_show
  get 'work-packages/:work_package/parse' => 'work_package#parse', as: :work_package_parse
  get 'work-packages/:work_package/parse/log' => 'work_package#log', as: :work_package_log
  
  get 'steps' => 'step#index', as: :step_list
  post 'steps/create' => 'step#create', as: :step_create
  
  get 'meta' => 'meta#index', as: :meta_list
  get 'meta/schema' => 'meta#schema', as: :meta_schema
  get 'meta/comments' => 'meta#comments', as: :meta_comments

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

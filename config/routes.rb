Rails.application.routes.draw do
  get 'home/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  get 'procedure-parser' => 'home#index', as: :home
  
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  
  get 'procedure-parsing/procedures' => 'procedure#index', as: :procedure_list
  get 'procedure-parsing/procedures/:procedure' => 'procedure#show', as: :procedure_show
  get 'procedure-parsing/procedures/:procedure/work-packages' => 'procedure#work_package_index', as: :procedure_work_package_list
  get 'procedure-parsing/procedures/:procedure/steps' => 'procedure#step_index', as: :procedure_step_list
  get 'procedure-parsing/procedures/:procedure/routes' => 'procedure#route_index', as: :procedure_route_list
  
  get 'procedure-parsing/work-packages/:work_package' => 'work_package#show', as: :work_package_show
  get 'procedure-parsing/work-packages/:work_package/parse' => 'work_package#parse', as: :work_package_parse
  get 'procedure-parsing/work-packages/:work_package/parse/log' => 'work_package#log', as: :work_package_log
  get 'procedure-parsing/work-packages/:work_package/parse/visualise' => 'work_package#visualise', as: :work_package_visualise
  get 'procedure-parsing/work-packages/:work_package/parse/skeleton' => 'work_package#skeleton', as: :work_package_skeleton
  
  get 'procedure-parsing/instruments/:instrument' => 'instrument#show', as: :instrument_show
  
  get 'procedure-parsing/meta' => 'meta#index', as: :meta_list
  get 'procedure-parsing/meta/schema' => 'meta#schema', as: :meta_schema
  get 'procedure-parsing/meta/comments' => 'meta#comments', as: :meta_comments
  get 'procedure-parsing/meta/bookmarklet' => 'meta#bookmarklet', as: :meta_bookmarklet
  get 'procedure-parsing/meta/link-check' => 'meta#link_check', as: :meta_link_check
  get 'procedure-parsing/meta/link-check/work-packages' => 'meta#link_check_work_package', as: :meta_link_check_work_package
  get 'procedure-parsing/meta/link-check/business-items' => 'meta#link_check_business_item', as: :meta_link_check_business_item

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

Galaman::Application.routes.draw do
  resources :splits


  devise_for :users

  scope "/admin" do
    resources :users
  end

  resources :competitions, :invitations, :dockets
  resources :clubs, :swimmers, :disciplines, :entries, :results 
  resources :qualifications, :qualification_times, :standards
  resources :roles, :assignments, :supports, :aims
  resources :relays, :seats

  resources :events do
    member do
      post 'list'
      post 'seed'
    end
  end

  get "admin" => 'admin#index'
  get "heats" => 'heats#index'
  get "lanes" => 'lanes#index'

  get "home/index"

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  root :to => "home#index"
end

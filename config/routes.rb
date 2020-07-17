Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  namespace :api do
      namespace :v1 do
        get '/items/find', to: 'items/find#show'
        get '/items/find_all', to: 'items/find#index'
        resources :items do 
          resources :merchant, controller: 'items/merchant'
        end
        get 'merchants/most_revenue', to: 'merchants/most_revenue#index'
        get 'merchants/most_items', to: 'merchants/most_items#index'
        get 'merchants/:id/revenue', to: 'merchants/revenue#show'
        get 'revenue', to: 'merchants/revenue#index'
        get 'merchants/find', to: 'merchants/find#show'
        get 'merchants/find_all', to: 'merchants/find#index'
        resources :merchants do 
          resources :items, controller: 'merchants/items'
        end
      end
  end
end

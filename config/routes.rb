Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  namespace :api do
    # scope module: 'api' do
      namespace :v1 do
        get '/items/find', to: 'items/find#show'
        get '/items/find_all', to: 'items/find#index'
        resources :items do 
          resources :merchant, controller: 'items/merchant'
        end
        get 'merchants/find', to: 'merchants/find#show' #can this be resource based?
        get 'merchants/find_all', to: 'merchants/find#index' #can this be resource based?
        resources :merchants do 
          resources :items, controller: 'merchants/items'
        end
      end
  end
end

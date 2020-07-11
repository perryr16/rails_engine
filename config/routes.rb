Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  namespace :api do
    # scope module: 'api' do
      namespace :v1 do
        resources :items do 
          resources :merchant, controller: 'items/merchant'
        end
        resources :merchants do 
          resources :items, controller: 'merchants/items'
        end
      end
  end
end

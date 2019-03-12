Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get 'find', to: 'search#show'
        get 'find_all', to: 'search#index'
        get 'random', to: 'random#show'
      end
      resources :merchants, only: [:show, :index] do
      end
      get '/merchants/:merchant_id/items', to: 'merchants/items#index'
      get '/merchants/:merchant_id/invoices', to: 'merchants/invoices#index'

      resources :items, only: [:show, :index]
    end
  end
end

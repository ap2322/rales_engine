Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      scope :merchants do
        get '/find', to: 'merchants/find#show'
        get '/find_all', to: 'merchants/find#index'
        get '/random', to: 'merchants/random#show'
        get '/most_revenue', to: 'merchants/most_revenue#index'
        get '/revenue', to: 'merchants/revenue#index'
      end
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], module: :merchants
        resources :invoices, only: [:index], module: :merchants
        get '/favorite_customer', to: 'merchants/favorite_customer#show'
      end

      scope :customers do
        get '/find', to: 'customers/find#show'
        get '/find_all', to: 'customers/find#index'
        get '/random', to: 'customers/random#show'
      end
      resources :customers, only: [:index, :show] do
        resources :invoices, only: [:index], module: :customers
        resources :transactions, only: [:index], module: :customers
        get 'favorite_merchant', to: 'customers/favorite_merchant#show'
      end

      scope :items do
        get '/find', to: 'items/find#show'
        get '/find_all', to: 'items/find#index'
        get '/random', to: 'items/random#show'
        get '/most_revenue', to: 'items/most_revenue#index'
      end
      resources :items, only: [:index, :show] do
        resources :invoice_items, only: [:index], module: :items
        resources :merchant, only: [:index], module: :items
        get '/best_day', to: 'items/best_day#show'
      end

      scope :invoices do
        get '/find', to: 'invoices/find#show'
        get '/find_all', to: 'invoices/find#index'
        get '/random', to: 'invoices/random#show'
      end
      resources :invoices, only: [:index, :show] do
        resources :transactions, only: [:index], module: :invoices
        resources :invoice_items, only: [:index], module: :invoices
        resources :items, only: [:index], module: :invoices
        get '/customer', to: 'invoices/customers#index'
        get '/merchant', to: 'invoices/merchants#index'
      end

      scope :transactions do
        get '/find', to: 'transactions/find#show'
        get '/find_all', to: 'transactions/find#index'
        get '/random', to: 'transactions/random#show'
      end
      resources :transactions, only: [:index, :show] do
        resources :invoice, only: [:index], module: :transactions
      end

      scope :invoice_items do
        get '/find', to: 'invoice_items/find#show'
        get '/find_all', to: 'invoice_items/find#index'
        get '/random', to: 'invoice_items/random#show'
      end
      resources :invoice_items, only: [:index, :show] do
        get '/invoice', to: 'invoice_items/invoice#index'
        get '/item', to: 'invoice_items/item#index'
      end
    end
  end
end

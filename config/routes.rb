Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      scope :merchants do
        get '/find', to: 'merchants#find'
        get '/find_all', to: 'merchants#find_all'
        get '/random', to: 'merchants#random'
        get '/most_revenue', to: 'merchants/most_revenue#index'
        get '/revenue', to: 'merchants/revenue#index'
      end
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], module: :merchants
        resources :invoices, only: [:index], module: :merchants
        get '/favorite_customer', to: 'merchants/favorite_customer#show'
      end

      scope :customers do
        get '/find', to: 'customers#find'
        get '/find_all', to: 'customers#find_all'
        get '/random', to: 'customers#random'
      end
      resources :customers, only: [:index, :show] do
        resources :invoices, only: [:index], module: :customers
        resources :transactions, only: [:index], module: :customers
      end

      scope :items do
        get '/find', to: 'items#find'
        get '/find_all', to: 'items#find_all'
        get '/random', to: 'items#random'
        get '/most_revenue', to: 'items/most_revenue#index'
      end
      resources :items, only: [:index, :show] do
        resources :invoice_items, only: [:index], module: :items
        resources :merchant, only: [:index], module: :items
        get '/best_day', to: 'items/best_day#show'
      end

      scope :invoices do
        get '/find', to: 'invoices#find'
        get '/find_all', to: 'invoices#find_all'
        get '/random', to: 'invoices#random'
      end
      resources :invoices, only: [:index, :show] do
        resources :transactions, only: [:index], module: :invoices
        resources :invoice_items, only: [:index], module: :invoices
        resources :items, only: [:index], module: :invoices
        get '/customer', to: 'invoices/customers#index'
        get '/merchant', to: 'invoices/merchants#index'
      end

      scope :transactions do
        get '/find', to: 'transactions#find'
        get '/find_all', to: 'transactions#find_all'
        get '/random', to: 'transactions#random'
      end
      resources :transactions, only: [:index, :show] do
        resources :invoice, only: [:index], module: :transactions
      end

      scope :invoice_items do
        get '/find', to: 'invoice_items#find'
        get '/find_all', to: 'invoice_items#find_all'
        get '/random', to: 'invoice_items#random'
      end
      resources :invoice_items, only: [:index, :show] do
        get '/invoice', to: 'invoice_items/invoice#index'
        get '/item', to: 'invoice_items/item#index'
      end
    end
  end
end

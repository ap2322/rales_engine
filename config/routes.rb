Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      scope :merchants do
        get '/find', to: 'merchants#find'
        get '/find_all', to: 'merchants#find_all'
        get '/random', to: 'merchants#random'
        get '/most_revenue', to: 'merchants#most_revenue'
      end
      resources :merchants, only: [:index, :show]

      scope :customers do
        get '/find', to: 'customers#find'
        get '/find_all', to: 'customers#find_all'
        get '/random', to: 'customers#random'
      end
      resources :customers, only: [:index, :show]

      scope :items do
        get '/find', to: 'items#find'
        get '/find_all', to: 'items#find_all'
        get '/random', to: 'items#random'
      end
      resources :items, only: [:index, :show]

      scope :invoices do
        get '/find', to: 'invoices#find'
        get '/find_all', to: 'invoices#find_all'
        get '/random', to: 'invoices#random'
      end
      resources :invoices, only: [:index, :show]

      scope :transactions do
        get '/find', to: 'transactions#find'
        get '/find_all', to: 'transactions#find_all'
        get '/random', to: 'transactions#random'
      end
      resources :transactions, only: [:index, :show]

      scope :invoice_items do
        get '/find', to: 'invoice_items#find'
        get '/find_all', to: 'invoice_items#find_all'
        get '/random', to: 'invoice_items#random'
      end
      resources :invoice_items, only: [:index, :show]
    end
  end
end

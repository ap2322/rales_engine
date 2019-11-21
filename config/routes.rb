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
    end
  end
end

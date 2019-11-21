Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants#find'
      get '/merchants/find_all', to: 'merchants#find_all'
      get '/merchants/random', to: 'merchants#random'
      get '/merchants/most_revenue', to: 'merchants#most_revenue'
      resources :merchants, only: [:index, :show]
    end
  end
end

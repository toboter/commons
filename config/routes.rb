Rails.application.routes.draw do
  
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy', as: 'signout'
  get 'search', to: 'subjects#index'
  
  resources :subjects do
    post 'upload', on: :collection
  end

  #namespace :api, defaults: {format: 'json'} do
  #  scope module: :v1 do
  #    resources :citations, only: [:index, :show] do
  #      collection do
  #        get 'search'
  #      end 
  #    end  
  #  end
  #end
  
  get '/api', to: 'home#api'
  get '/help', to: 'home#help'

  root 'home#index' 
 
end

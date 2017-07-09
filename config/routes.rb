Rails.application.routes.draw do
  # added by nabu
  concern :commentable do
    resources :comments, only: [:index, :new, :create, :destroy]
  end
  # 'concerns: :commentable' needs to be added to any resource where nabu is included.

  resources :subjects, only: [:index, :show, :new, :create]

  resources :audios, controller: 'subjects', type: 'Audio', concerns: :commentable
  resources :documents, controller: 'subjects', type: 'Document', concerns: :commentable
  resources :images, controller: 'subjects', type: 'Image', concerns: :commentable
  resources :videos, controller: 'subjects', type: 'Video', concerns: :commentable

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1 do
      resources :commons, only: [:index, :show] do
        collection do
          get 'search'
        end
      end  
    end
  end
  
  get '/api', to: 'home#api'
  get '/help', to: 'home#help'

  root 'home#index' 
 
end

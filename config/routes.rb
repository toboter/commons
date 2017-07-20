Rails.application.routes.draw do
  # added by nabu
  concern :commentable do
    resources :comments, only: [:index, :new, :create, :destroy]
  end
  # 'concerns: :commentable' needs to be added to any resource where nabu is included.

  resources :subjects, only: [:index, :new, :create] do
    member do
      get "file", to: "subjects#view_file"
    end
  end

  resources :audios, controller: 'audios', type: 'Audio', concerns: :commentable, except: [:index, :new, :create]
  resources :documents, controller: 'documents', type: 'Document', concerns: :commentable, except: [:index, :new, :create]
  resources :images, controller: 'images', type: 'Image', concerns: :commentable, except: [:index, :new, :create]
  resources :videos, controller: 'videos', type: 'Video', concerns: :commentable, except: [:index, :new, :create]

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1 do
      resources :commons, only: [:index, :show] do
        collection do
          get 'search'
        end
        member do
          get "file", to: "commons#view_file"
        end
      end  
    end
  end
  
  get '/api', to: 'home#api'
  get '/help', to: 'home#help'

  root 'home#index' 
 
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'races#index', defaults: { category: :all }

  resources :users do
    get 'account'
    get 'histories(/:type)', to: 'histories#index', as: 'histories', defaults: { type: :all }
    get 'import'
  end

  get 'races(/category/:category)', to: 'races#index', as: 'races', defaults: { category: :all }
  resources :races, except: :index do
    put 'start', to: 'races#start'
    member do
      get :data_series
      get :chat_members
    end
    resources :lanes, param: :lane_id do
      post 'offers', to: 'offers#create', as: 'offers'
    end
    put 'oracle/:user_id', to: 'races#assign_to_oracle', as: 'assign_to_oracle'
  end

  scope :chat_rooms, defaults: { format: :json } do
    get ':race_id/join/:user_id', to: 'chat_rooms#join'
    get ':race_id/user_info/:user_id', to: 'chat_rooms#user_info'
    get ':race_id/update', to: 'chat_rooms#update'
  end

  get     '/signup',  to: 'users#new'
  post    '/signup',  to: 'users#create'
  get     '/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'

  get 'auth/:provider/callback', to: 'sessions#omniauth'
  get 'auth/failure', to: redirect('/')

  resources :user_activations, only: [:edit]
  resources :reset_password, only: [:new, :create, :edit, :update]

  namespace :admin do
    root to: 'races#index'
    resources :races, only: [:index, :show]
    resources :users, only: [:index, :show, :edit]
  end

  resources :transactions

  get 'privacy', to: 'static_pages#privacy'
  get 'terms', to: 'static_pages#terms'
end

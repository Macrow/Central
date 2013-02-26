# -*- encoding : utf-8 -*-
Central::Application.routes.draw do
  root :to => 'users#index'
  
  # session
  get  'login'                => 'sessions#new', as: 'login'
  post 'login'                => 'sessions#create'
  get  'logout'               => 'sessions#destroy', as: 'logout'
  post 'create_from_omniauth' => 'sessions#create_from_omniauth'

  # users
  get  'register'  => 'users#new',    as: 'register'
  post 'users'     => 'users#create', as: 'users'
  get  'users/all' => 'users#all',    as: 'all_users'
  get  'users/:id' => 'users#show',   as: 'user'
    
  # current user
  get 'profile'                 => 'profiles#show',            as: 'profile'
  get 'profile/edit'            => 'profiles#edit',            as: 'edit_profile'
  put 'profile'                 => 'profiles#update',          as: 'update_profile'
  get 'profile/tags'            => 'profiles#tags',            as: 'tags'
  get 'profile/edit_avatar'     => 'profiles#edit_avatar',     as: 'edit_avatar'
  get 'profile/crop_avatar'     => 'profiles#crop_avatar',     as: 'crop_avatar'
  put 'profile/update_avatar'   => 'profiles#update_avatar',   as: 'update_avatar'
  get 'profile/edit_password'   => 'profiles#edit_password',   as: 'edit_password'
  put 'profile/update_password' => 'profiles#update_password', as: 'update_password'
  
  # watching
  resources :relationships, only: [:create, :destroy]
  
  # password reset
  resources :password_resets, only: [:new, :create, :edit, :update]
  
  # omniauth
  match '/auth/:provider/callback', to: 'sessions#create_from_omniauth'
  match '/auth/failure', to: redirect('/')
  
  # messages & notifications
  resources :messages do
    collection do
      get 'unread'
      get 'outbox'
      delete 'group_destroy'
    end
  end
  resources :notifications do
    collection do
      get 'unread'
      delete 'group_destroy'
    end
  end
  
  # captcha
  captcha_route
  
  # admin
  namespace :admin do
    root :to => 'home#index'
    resource :home, only: [:edit, :update], controller: 'home'
    resources :users do
      collection do
        get 'admins'
        get 'fetch'
        delete 'group_destroy'
      end
    end
    resources :groups
    resources :messages do
      delete 'group_destroy', on: :collection
    end
    resources :notifications do
      delete 'group_destroy', on: :collection
    end
    resources :scores do
      collection do
        get 'reset'
        put 'do_reset'
      end
    end
    resources :tags
  end
end

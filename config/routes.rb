Rails.application.routes.draw do
  
  
  root 'contributions#index'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get 'sign_in', to: 'users/sessions#new', as: :new_user_session
    get 'sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
  end
  
  get 'newest', to: 'contributions#newest', as: 'newest'
  get 'submit', to: 'contributions#new'
  get ':id', to: 'contributions#newest'
  put ':id', to: 'contributions#like'

  
  
  resources :contributions, :path => "/"
  resources :users
  
end
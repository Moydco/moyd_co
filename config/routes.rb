Rails.application.routes.draw do
  devise_for :users

  resources :statics, only: [:index, :create]

  root to: 'statics#index'
end

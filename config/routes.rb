Rails.application.routes.draw do

  resources :dashboard, only: [:index, :create, :update] do
    collection do
      put :update_password
    end
  end

  resources :quick_books, only: [:index] do
    collection do
      get :authenticate
      get :oauth_callback
    end
  end

  devise_for :users, controllers: {
      passwords: 'users/passwords'
  }

  resources :statics, only: [:index, :create] do
    collection do
      get :support
      get :team
      get :contact_us
    end
  end

  root to: 'statics#index'
end

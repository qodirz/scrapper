Rails.application.routes.draw do
  resources :clients do
    member do
      post :sync
    end
  end
  devise_for :users
  root to: 'clients#index'
end

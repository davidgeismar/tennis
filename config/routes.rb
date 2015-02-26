Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }


  resource :judge, only: :show
  resources :tournaments, only: [:index, :show, :new, :create] do
    resources :subscriptions, only: [:show, :create, :index, :update]
  end

  resources :subscriptions, only: [] do
    resources :convocations, only: [:new, :create]
  end

  # get "tournaments", to: "tournaments#index"
  resource :user do
    resources :tournaments, only: [:show, :new, :create, :edit, :update]
  end

  resources :convocations, only: [:edit, :update]



  #get 'tournaments/:tournament_id/subscriptions/profile', to: 'subscriptions#profile', as: 'subscription_profil'
  # get "user/tournaments/:tournament_id/subscription_pending ", to: "subscriptions#pending", as: "subscription_pending"
end

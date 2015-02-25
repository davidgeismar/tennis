Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }


  resource :judge, only: :show
  resources :tournaments, only: [:index, :show] do
    resources :subscriptions, only: [:show, :create]
  end

  # get "tournaments", to: "tournaments#index"

  resource :user do
    resources :tournaments, only: [:show, :new, :create, :edit, :update]
  end

  # get "user/tournaments/:tournament_id/subscription_pending ", to: "subscriptions#pending", as: "subscription_pending"
end

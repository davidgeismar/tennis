Rails.application.routes.draw do

  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: 'users/registrations', invitations: 'users/invitations', omniauth_callbacks: "users/omniauth_callbacks" }

  # root to: "home#home"
  resources :contacts, only: [:new, :create]
  resource :judge, only: :show
  resources :tournaments, only: [:index, :show, :new, :create] do
    post :registrate_card, on: :member
    resources :subscriptions, only: [:new, :show, :create, :index, :update]
  end
  post 'tournaments/:tournament_id/convocations/multiple_new', to: "convocations#multiple_new", as: "multiple_new"
  post 'tournaments/:tournament_id/convocation/multiple_create', to: "convocations#multiple_create", as: "multiple_create"
  # post '/tournaments/:tournament_id/subscriptions/new', to: "subscriptions#new", as: "pipi"
  post 'transfers/:tournament_id', to: "transfers#create", as: "transfers"

  resources :subscriptions do
    resources :convocations, only: [:new, :create]
  end

  resources :transfers, only: :create do
    get :mangopay_return, on: :collection
  end
   get "tournaments/:tournament_id:/success", to: "tournaments#success_payment", as: "success"
  # resources :users, only: [:edit, :show, :update] do
  #   get :card, on: :member
  #   # get :rdstr_card_registration, on: :member
  #   post :registrate_card, on: :member
  #   # post :registrate_rdstr_card, on: :member

  # end
  post "updatenotif", to: "notifications#update_notif", as: "update_notification"
  get "contact", to: "messages#contact", as: "contact"
  get "messages", to: "tournaments#index", as: "messages"
  get "mestournois", to: "subscriptions#mytournaments", as: "mes_tournois"
  get "tournaments/:id/invite_player", to: "tournaments#invite_player", as: "invite_player"
  post "tournaments/:id/invite_player", to: "tournaments#invite_player_to_tournament"
  post 'tournaments/results', to: "tournaments#results", as: "tournaments_results"
  resources :users, only: [:update, :show, :edit] do
    resources :tournaments, only: [:show, :new, :create, :edit, :update]
  end

  resources :convocations, only: [:edit, :update] do
    resources :messages
  end
  # resources :user, only: :show, as: "show_user"

  patch 'registercard/:id', to:"users#update_card", as: "register"


  #get 'tournaments/:tournament_id/subscriptions/profile', to: 'subscriptions#profile', as: 'subscription_profil'
  # get "user/tournaments/:tournament_id/subscription_pending ", to: "subscriptions#pending", as: "subscription_pending"
end

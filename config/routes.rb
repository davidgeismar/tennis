Rails.application.routes.draw do

  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: 'users/registrations', invitations: 'users/invitations', omniauth_callbacks: "users/omniauth_callbacks" }

  # root to: "home#home"
  resources :contacts, only: [:new, :create]
  resource :judge, only: :show
  resources :tournaments, only: [:index, :show, :new, :create, :update] do
    post :registrate_card, on: :member
    resources :subscriptions, only: [:new, :show, :create, :index, :update] #en ai je vraiment besoin de ces routes
  end
  post 'tournaments/:tournament_id/convocations/multiple_new', to: "convocations#multiple_new", as: "multiple_new"
  post 'tournaments/:tournament_id/convocation/multiple_create', to: "convocations#multiple_create", as: "multiple_create"

  post 'transfers/:tournament_id', to: "transfers#create", as: "transfers"
  post 'refunds/:subscription_id', to: "subscriptions#refund", as: "refund"
  post 'accept_player/:subscription_id', to: "subscriptions#accept_player", as: "accept_player"

  post 'refusal/:subscription_id', to: "subscriptions#refus_without_remboursement", as: "refusal"

  resources :subscriptions do
    resources :convocations, only: [:new, :create]
  end

  resources :subscriptions do
    resources :disponibilities, only: [:new, :create, :edit, :update, :show]
  end

  resources :transfers, only: :create do
    get :mangopay_return, on: :collection
  end
   get "tournaments/:tournament_id/success", to: "tournaments#success_payment", as: "success" #should be subscriptions/:subscription_id/success


  post "tournament/:tournament_id/AEIexport", to: "tournaments#AEIexport", as: "AEIexport"
  post "tournament/:tournament_id/AEIinfo", to: "tournaments#AEIinfo", as: "AEIinfo"
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

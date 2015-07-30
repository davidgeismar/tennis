Rails.application.routes.draw do
  # root to: "home#home" # homepage via HighVoltage

  ActiveAdmin.routes(self)

  devise_for :users, controllers: {
    registrations:      'users/registrations',
    invitations:        'users/invitations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resource  :judge,     only: :show
  resources :contacts,  only: [:new, :create]

  resources :convocations, only: [:edit, :update] do # JOUEUR
    resources :messages
  end

  resources :users, only: [:update, :show, :edit] do
    resources :tournaments, only: [:show, :new, :create, :edit, :update]
  end

  # tournaments

  resources :tournaments, only: [:index, :show, :new, :create, :update] do
    resource  :aei_export,          only: [:create]
    resource  :rankings,            only: [:show]

    resources :player_invitations,  only: [:new, :create]
    resources :subscriptions,       only: [:new, :show, :create, :index, :update]
    resources :transfers,           only: [:create]
  end

  post 'tournaments/:tournament_id/convocations/multiple_new',    to: "convocations#multiple_new",    as: "multiple_new"
  post 'tournaments/:tournament_id/convocations/multiple_create', to: "convocations#multiple_create", as: "multiple_create"
  post 'tournaments/:tournament_id/updaterankings',               to: "tournaments#update_rankings",  as: "updaterankings"

  # subscriptions

  get "mestournois", to: "subscriptions#mytournaments", as: "mes_tournois"

  resources :subscriptions, only: [] do
    member do
      post 'accept'
      post 'refund'
      post 'refuse'
    end

    resources :convocations,    only: [:new, :create] # JA
    resources :disponibilities, only: [:new, :create, :edit, :update, :show]
  end

  # notifs
  resource :notification_update, only: [:create]
end

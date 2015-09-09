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
  resources :tournaments do
    resources :competitions
  end

  resources :competitions do
    resources :subscriptions
    resources :player_invitations,  only: [:new, :create]
    resource  :rankings,            only: [:show]
    resource  :aei_export,          only: [:create]
  end

  resources :tournaments, only: [:index, :show, :new, :create, :update] do
    resources :player_invitations,  only: [:new, :create]
    resources :subscriptions,       only: [:new, :show, :create, :index, :update]
    resources :transfers,           only: [:create]
  end

  post 'competitions/:competition_id/convocations/multiple_new',    to: "convocations#multiple_new",    as: "multiple_new"
  post 'competitions/:competition_id/convocations/multiple_create', to: "convocations#multiple_create", as: "multiple_create"
  post 'competitions/:competition_id/updaterankings',               to: "competitions#update_rankings",  as: "updaterankings"
  get  'users/:user_id/passed_tournaments',                       to: "tournaments#passed_tournaments",  as: "passed_tournaments"
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

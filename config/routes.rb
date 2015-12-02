Rails.application.routes.draw do
  # root to: 'home#home' # homepage via HighVoltage
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  ActiveAdmin.routes(self)

  devise_for :users, controllers: {
    registrations:      'users/registrations',
    invitations:        'users/invitations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resource  :judge,     only: :show
  resources :contacts,  only: [:new, :create]

  resources :convocations, only: [:edit, :update] do # JOUEUR
    resources :messages, only: [] #no message routes for now
  end


  resources :users, only: [:update, :show, :edit] do
    resources :tournaments, only: [:show, :new, :create, :edit, :update, :destroy]
  end

  resources :tournaments, only: [:index, :show, :new, :create, :update] do
    resources :competitions
    resources :disponibilities, only: [:show, :new, :create, :edit, :update]
  end

  resources :competitions, only: [:index, :show, :new, :create, :update] do
    resources :subscriptions,       only: [:create, :index, :update]
    resources :player_invitations,  only: [:new, :create]
    resource  :rankings,            only: [:show]
    resource  :aei_export,          only: [:create]
  end

  resources :mytournaments, only: [:index] do
    collection do
      get :passed
    end
  end

  post 'competitions/:competition_id/disponibility_export',         to: 'aei_exports#export_disponibilities', as: 'export_disponibilities'
  post 'competitions/:competition_id/convocations/multiple_new',    to: 'convocations#multiple_new',          as: 'multiple_new'
  post 'competitions/:competition_id/convocations/multiple_create', to: 'convocations#multiple_create',       as: 'multiple_create'
  post 'competitions/:competition_id/updaterankings',               to: 'competitions#update_rankings',       as: 'updaterankings'

  post 'tournaments/:tournament_id/subscriptions/multiple_new',     to: 'subscriptions#multiple_new',         as: 'multiple_new_subscriptions'
  post 'tournaments/:tournament_id/subscriptions/multiple_create',  to: 'subscriptions#multiple_create',      as: 'multiple_create_subscriptions'

  resources :subscriptions, only: [] do
    member do
      post 'accept'
      post 'refund'
      post 'refuse'
    end

    resources :convocations,    only: [:new, :create] # JA
    resources :disponibilities, only: [:new, :create, :edit, :update, :show]
  end

  resource :notification_update, only: [:create]
end

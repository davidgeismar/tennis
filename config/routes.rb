Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  resource :user
  resource :judge, only: :show
end

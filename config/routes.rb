Rails.application.routes.draw do
  get 'home/index'

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root "home#index"
end

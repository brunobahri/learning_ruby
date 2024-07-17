# config/routes.rb
Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :tasks

  # Garantir que o login e logout utilizem POST e DELETE respectivamente
  post 'login', to: 'users/sessions#create'
  delete 'logout', to: 'users/sessions#destroy'
end

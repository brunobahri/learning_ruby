Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  resources :tasks

  post 'login', to: 'users/sessions#create'
  delete 'logout', to: 'users/sessions#destroy'
end

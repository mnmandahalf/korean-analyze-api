Rails.application.routes.draw do
  root 'application#health'
  resources :analyze, only: [:index]
  get 'analysis', to: 'analyze#index'
end

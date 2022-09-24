Rails.application.routes.draw do
  root 'application#health'
  resources :analyze, only: [:index]
end

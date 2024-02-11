Rails.application.routes.draw do
  resources :tasks
  resources :projects
  namespace :api do
    resources :tasks, only: [:index, :update]
    resources :projects, only: [:index, :update]
  end
  root "tasks#index"
end

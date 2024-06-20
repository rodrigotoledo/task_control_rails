Rails.application.routes.draw do
  resources :tasks, except: :show
  resources :projects, except: :show
  namespace :api do
    resources :tasks, only: %i[index show create update destroy] do
      member do
        patch :mark_as_completed, :mark_as_incompleted
      end
    end
    resources :projects, only: %i[index show create update destroy] do
      member do
        patch :mark_as_completed, :mark_as_incompleted
      end
    end
  end
  root 'tasks#index'
end

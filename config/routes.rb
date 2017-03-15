Sup::Application.routes.draw do
  root to: 'members#graph'

  resources :members do
    collection do
      get 'graph'
      get 'slack_import'
      post 'import_selected'
    end
  end

  resources :meetings, only: [:edit, :update]
  resources :feedbacks, only: [:new, :create]
  resources :team, only: :index
end

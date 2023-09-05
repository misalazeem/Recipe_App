Rails.application.routes.draw do
  devise_for :users


  # Defines the root path route ("/")
  # root "articles#index"
  resources :foods, only: [:index, :show, :new, :create, :destroy]

  authenticated :user do
    root 'recipes#index', as: :authenticated_root
  end

  root to: 'welcome#index'

  resources :recipes do
    member do
      delete :destroy
    end
  end

end

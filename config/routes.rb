Rails.application.routes.draw do
  devise_for :users

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

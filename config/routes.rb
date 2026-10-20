
Rails.application.routes.draw do
  devise_for :users

  root to: "pages#home"

  resources :conversations do
    resources :messages, only: [:create]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end

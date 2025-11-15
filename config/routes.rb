Rails.application.routes.draw do
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root to: 'pages#home'
  resources :trips, only: %i[index show new create edit update] do
    member do
      get :review_suggestions
    end
    resources :itineraries, only: %i[show create]
  end

  # Route permettant de passer invitation_accepted de false à true en cas d'acceptation de l'invitation.
  resources :user_trip_statuses, only: [] do
    member do
      patch :accept_invitation
    end
  end
end

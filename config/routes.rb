Rails.application.routes.draw do
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root to: 'pages#home'

  resources :preferences_forms do
    member do
      get :step2
      get :step3
    end
  end

  resources :trips, only: %i[index show new create edit update] do
    member do
      get :review_suggestions
      get :invite
      post :add_participants
    end
    resources :itineraries, only: %i[show create]
  end

  # Style guide (accessible uniquement en dev)
  get 'styleguide', to: 'pages#styleguide' if Rails.env.development?

  # Route permettant de passer invitation_accepted de false à true en cas d'acceptation de l'invitation.
  resources :user_trip_statuses, only: [] do
    member do
      patch :accept_invitation
    end
  end

  # Route pour la page de review des recommendations
  resources :trips do
    get 'recommendations/review', to: 'recommendations#review', as: 'review_recommendations'
  end

  # Routes pour les actions like/dislike (pour plus tard)
  resources :recommendation_items, only: [] do
    member do
      patch :like
      patch :dislike
    end
  end
end

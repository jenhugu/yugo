class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :get_inspired]

  def home
  end

  def styleguide
    # Chargement de données de test
    @sample_activity = ActivityItem.first
  end

  def get_inspired
    # Récupérer 9 activités aléatoires
    @activities = ActivityItem.order("RANDOM()").limit(9)
  end

  def get_inspired_more
    # Récupérer 3 activités aléatoires supplémentaires pour le lazy loading
    @activities = ActivityItem.order("RANDOM()").limit(3)
    render :get_inspired_cards, layout: false
  end

  private

  def get_inspired_cards
    # Partial view pour les cartes (utilisé par le lazy loading)
  end
end

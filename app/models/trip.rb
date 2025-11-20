# frozen_string_literal: true

class Trip < ApplicationRecord
  has_many :recommendations, dependent: :destroy
  has_many :itineraries, dependent: :destroy
  has_many :user_trip_statuses, dependent: :destroy
  has_many :users, through: :user_trip_statuses
  has_many :recommendation_items, through: :recommendations
  has_many :itinerary_items, through: :itineraries
  has_many :preferences_forms, through: :user_trip_statuses

  # Vérifie si tous les participants ont rempli leur formulaire
  def all_forms_filled?
    user_trip_statuses.all? { |status| status.form_filled == true }
  end

  # Génère les recommendations si tous les forms sont remplis
  def generate_recommendations_if_ready
    return false unless all_forms_filled?

    # Vérifier qu'on n'a pas déjà généré des recommendations
    return false if recommendations.where(accepted: nil).any?

    RecommendationGenerator.new(self).call
    true
  end

  # Récupère le créateur du trip
  def creator
    user_trip_statuses.find_by(role: "creator")&.user
  end

  # Récupère le preferences_form du créateur
  def creator_preferences_form
    creator_status = user_trip_statuses.find_by(role: "creator")
    creator_status&.preferences_form
  end
end

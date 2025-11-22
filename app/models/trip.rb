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

    # ========================================================================
    # MODIFICATION POUR PERMETTRE REGÉNÉRATION APRÈS REJET - CODE COMMENTÉ
    # ========================================================================
    # AVANT DE DÉCOMMENTER : Vérifier si cette modification n'a pas déjà été
    # faite par quelqu'un d'autre dans l'équipe.
    #
    # ACTUELLEMENT : Cette ligne bloque la génération si une recommendation
    # existe déjà (même si elle a été rejetée).
    #
    # MODIFICATION PROPOSÉE : Permettre de générer une nouvelle recommendation
    # même si une précédente existe, tant qu'elle a été votée (accepted != nil).
    #
    # Voir le bloc de commentaires après cette méthode pour l'explication
    # complète du problème.
    # ========================================================================
    #
    # # Version originale (actuellement active) :
    return false if recommendations.where(accepted: nil).any?
    #
    # # Version modifiée (à activer pour permettre la regénération) :
    # # Ne bloquer QUE s'il y a une recommendation en attente de votes
    # # return false if recommendations.where(accepted: nil).any?
    #

    RecommendationGenerator.new(self).call
    true
  end

  # ============================================================================
  # GESTION DU REJET DE RECOMMENDATIONS - CODE COMMENTÉ
  # ============================================================================
  # PROBLÈME IDENTIFIÉ :
  # Dans app/controllers/recommendation_items_controller.rb:51-64, quand
  # verify_and_generate_itinerary! retourne false, on affiche le message
  # "Waiting for other participants..." dans TOUS les cas.
  #
  # Or, il y a DEUX cas possibles quand all_done == false :
  # 1. D'autres utilisateurs n'ont pas encore voté → Message correct ✓
  # 2. Tous ont voté MAIS recommendation rejetée → Message INCORRECT ✗
  #
  # Dans le cas 2, les participants vont attendre indéfiniment car tout le
  # monde a déjà voté ! Il faut générer une nouvelle recommendation.
  #
  # AVANT DE DÉCOMMENTER : Vérifier si cette fonctionnalité n'a pas déjà été
  # implémentée par quelqu'un d'autre dans l'équipe.
  #
  # Fichiers concernés par cette problématique :
  # - app/models/trip.rb (ce fichier)
  # - app/models/recommendation.rb (méthode verify_and_generate_itinerary!)
  # - app/controllers/recommendation_items_controller.rb (lignes 51-64)
  #
  # Solution proposée :
  # - Quand une recommendation est rejetée, créer automatiquement une nouvelle
  # - Garder l'historique des votes (pour ne pas re-proposer les mêmes activités)
  # - Réinitialiser recommendation_reviewed pour permettre un nouveau vote
  # ============================================================================
  #
  # # Réinitialise le statut recommendation_reviewed pour permettre un nouveau vote
  # # Garde l'historique des votes précédents pour ne pas re-proposer les activités rejetées
  # def reset_recommendation_status_for_new_round!
  #   user_trip_statuses.update_all(recommendation_reviewed: false)
  # end
  #
  # # Génère une nouvelle recommendation après un rejet
  # # Prend en compte les votes précédents pour éviter les activités déjà rejetées
  # def generate_new_recommendation_after_rejection!
  #   reset_recommendation_status_for_new_round!
  #
  #   # Le RecommendationGenerator devrait utiliser les votes précédents
  #   # pour ne pas re-proposer les activités avec trop de dislikes
  #   RecommendationGenerator.new(self).call
  # end

  # Récupère le créateur du trip
  def creator
    user_trip_statuses.find_by(role: "creator")&.user
  end

  # Récupère le preferences_form du créateur
  def creator_preferences_form
    creator_status = user_trip_statuses.find_by(role: "creator")
    creator_status&.preferences_form
  end

  # Vérifie si tous les utilisateurs ont terminé de voter
  def votes_completed?
    return false unless all_forms_filled?

    latest_recommendation = recommendations.where.not(accepted: nil).last
    return false unless latest_recommendation

    user_trip_statuses.all? { |status| status.recommendation_reviewed == true }
  end

  # Vérifie si les votes sont en accord (accepted: true)
  def votes_match?
    return false unless votes_completed?

    latest_recommendation = recommendations.where.not(accepted: nil).last
    latest_recommendation&.accepted == true
  end

  # Vérifie si les votes sont en désaccord (accepted: false)
  def votes_dont_match?
    return false unless votes_completed?

    latest_recommendation = recommendations.where.not(accepted: nil).last
    latest_recommendation&.accepted == false
  end
end

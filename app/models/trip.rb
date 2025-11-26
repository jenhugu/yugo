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
    return false if recommendations.where(accepted: nil).any?

    RecommendationGenerator.new(self).call
    true
  end

  # Réinitialise le statut recommendation_reviewed
  def reset_recommendation_status_for_new_round!
    user_trip_statuses.update_all(recommendation_reviewed: false)
  end

  #  Génère une nouvelle recommendation après un rejet
  def generate_new_recommendation_after_rejection!
    reset_recommendation_status_for_new_round!
    RecommendationGenerator.new(self).call
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

  # ============================================================================
  # MÉTHODES DE COMPTAGE DES STATUTS
  # ============================================================================

  # Compte le nombre d'invitations en attente
  def pending_invitations_count
    user_trip_statuses.where(invitation_accepted: false).count
  end

  # Compte le nombre d'utilisateurs qui doivent encore remplir leurs préférences
  def pending_preferences_count
    user_trip_statuses.where(invitation_accepted: true, form_filled: false).count
  end

  # Compte le nombre d'utilisateurs qui doivent encore reviewer les suggestions
  # Retourne 0 s'il n'y a pas encore de recommendations à reviewer
  def reviewing_suggestions_count
    return 0 unless recommendations.where(accepted: nil).any?

    user_trip_statuses.where(recommendation_reviewed: false, form_filled: true).count
  end

  # Compte le nombre d'utilisateurs qui ont tout complété
  # (invitation acceptée + préférences remplies + recommendation reviewée)
  # = "There yugo" (ils peuvent y aller)
  def ready_to_go_count
    user_trip_statuses.where(
      invitation_accepted: true,
      form_filled: true,
      recommendation_reviewed: true
    ).count
  end

  # ============================================================================
  # MÉTHODES POUR RÉCUPÉRER LES UTILISATEURS PAR STATUT
  # ============================================================================

  # Récupère les utilisateurs avec invitations en attente
  def pending_invitation_users
    user_trip_statuses.where(invitation_accepted: false).includes(:user).map(&:user)
  end

  # Récupère les utilisateurs qui doivent encore remplir leurs préférences
  def pending_preferences_users
    user_trip_statuses.where(invitation_accepted: true, form_filled: false).includes(:user).map(&:user)
  end

  # Récupère les utilisateurs qui doivent encore reviewer les suggestions
  def reviewing_suggestions_users
    return [] unless recommendations.where(accepted: nil).any?

    user_trip_statuses.where(recommendation_reviewed: false, form_filled: true).includes(:user).map(&:user)
  end

  # Récupère les utilisateurs qui ont tout complété ("There yugo")
  def ready_to_go_users
    user_trip_statuses.where(
      invitation_accepted: true,
      form_filled: true,
      recommendation_reviewed: true
    ).includes(:user).map(&:user)
  end
end

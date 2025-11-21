# frozen_string_literal: true

class RecommendationItemsController < ApplicationController
  before_action :set_recommendation_item, only: [:like, :dislike]

  def like
    check_review_completion(true)
  end

  def dislike
    check_review_completion(false)
  end

  private

  def set_recommendation_item
    @recommendation_item = RecommendationItem.find(params[:id])
    @recommendation = @recommendation_item.recommendation
    @trip = @recommendation.trip
  end

  def check_review_completion(liked)
    # Vérifier que l'utilisateur est participant du trip
    user_trip_status = @trip.user_trip_statuses.find_by(user: current_user)
    return head :forbidden unless user_trip_status

    Rails.logger.info "=== RECOMMENDATION VOTE ==="
    Rails.logger.info "Item ID: #{@recommendation_item.id}"
    Rails.logger.info "User: #{current_user.email}"
    Rails.logger.info "Like: #{liked}"

    # Créer ou mettre à jour le vote
    RecommendationVote.find_or_create_by(
      user_trip_status: user_trip_status,
      recommendation_item: @recommendation_item
    ).update(like: liked)

    # Vérifier si cet utilisateur a reviewé tous les items
    total_items = @recommendation.recommendation_items.count
    voted_items = user_trip_status.recommendation_votes.count
    unreviewed_by_user = total_items - voted_items
    Rails.logger.info "Total items: #{total_items}, Voted items: #{voted_items}, Unreviewed items: #{unreviewed_by_user}"

    if unreviewed_by_user == 0
      # Cet utilisateur a voté sur tous les items
      user_trip_status.update(recommendation_reviewed: true)

      # Vérifier si tous les utilisateurs ont reviewé
      if @recommendation.all_users_reviewed?
        @recommendation.calculate_acceptance!

        # Déclencher le job GenerateItinerary si accepté
        # GenerateItineraryJob.perform_later(@recommendation.id) if @recommendation.accepted

        # Renvoyer une réponse JSON indiquant que c'est terminé pour tous
        render json: {
          completed: true,
          message: "Suggestions successfully reviewed"
        }
      else
        # Cet utilisateur a reviewé tous ses items, mais d'autres attendent encore
        # Rediriger vers la page du trip pour attendre les autres
        render json: {
          completed: true,
          message: "You've reviewed all suggestions. Waiting for other participants..."
        }
      end
    else
      # Pour l'Option A : juste renvoyer 204 No Content, le JavaScript va recharger la page
      head :no_content
    end
  end
end

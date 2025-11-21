class RecommendationsController < ApplicationController
  before_action :set_trip

  def review
    # Récupérer la dernière recommendation du trip
    @recommendation = @trip.recommendations.where(accepted: nil).last

    # Si pas de recommendation, rediriger
    unless @recommendation
      redirect_to @trip, alert: "No recommendations available yet."
      return
    end

    # Récupérer le UserTripStatus de l'utilisateur actuel
    user_trip_status = @trip.user_trip_statuses.find_by(user: current_user)
    unless user_trip_status
      redirect_to @trip, alert: "You are not a participant in this trip."
      return
    end

    # Récupérer tous les recommendation_items
    @recommendation_items = @recommendation.recommendation_items.includes(:activity_item)

    # Récupérer le premier item non voté par cet utilisateur
    @current_item = @recommendation_items.find do |item|
      !user_trip_status.recommendation_votes.exists?(recommendation_item: item)
    end

    # Si tous les items ont été reviewés par cet utilisateur
    unless @current_item
      redirect_to @trip, notice: "You've reviewed all recommendations!"
      return
    end

    # Calculer la position actuelle (pour afficher "X/10")
    @current_position = @recommendation_items.index(@current_item) + 1
    @total_items = @recommendation_items.count
  end

  private

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

  def verify_acceptance_recommendation
    # verfier a chaque vote pour permettre ensuite le background job
    # a mettre dans le controleur recommendation, si retourne false alors ne fais
    # rien mais si retourne true alors déclenche dans dossier job la fonction LLM
    # generate_itinerary
    # user_trip_status = UserTripStatus.find
    # recommendation = recommendation.find
    if recommendation.accepted && user_trip_status.recommendation_reviewed
      # alors déclenche generate_itinerary job
    end
  end
end

class RecommendationsController < ApplicationController
  before_action :set_trip

  def review
    # Debug
    Rails.logger.info "=== DEBUG RECOMMENDATIONS ==="
    Rails.logger.info "Trip ID: #{@trip.id}"
    Rails.logger.info "Total recommendations: #{@trip.recommendations.count}"
    Rails.logger.info "Recommendations with accepted=nil: #{@trip.recommendations.where(accepted: nil).count}"

    # Récupérer la dernière recommendation du trip
    @recommendation = @trip.recommendations.where(accepted: nil).last

    Rails.logger.info "Found recommendation: #{@recommendation.inspect}"

    # Si pas de recommendation, rediriger
    unless @recommendation
      Rails.logger.info "No recommendation found - redirecting"
      redirect_to @trip, alert: "No recommendations available yet."
      return
    end

    # Récupérer tous les recommendation_items
    @recommendation_items = @recommendation.recommendation_items.includes(:activity_item)

    Rails.logger.info "Recommendation items count: #{@recommendation_items.count}"

    # Récupérer le premier item non reviewé (like = nil)
    @current_item = @recommendation_items.find { |item| item.like.nil? }

    # Si tous les items ont été reviewés
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
end

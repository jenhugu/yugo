class ItinerariesController < ApplicationController

  def show
    @trip = Trip.find(params[:trip_id])
    @itinerary = @trip.itineraries.find(params[:id])
  end

  private

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

class ItinerariesController < ApplicationController
  before_action :recommendation_ok, only: [:create]

  def show
    @trip = Trip.find(params[:trip_id])
    @itinerary = @trip.itineraries.find(params[:id])
  end

  def create
    # Déclencher quand la recommendation est validée
    # idee : if recommendation_reviewed = true && recommendation = accepted then LLM
    # il faut aller lire dans user_trip_status throught trip si recommendation_reviewed = true
    # il faut aller lire dans recommendation throught trip si accepted = true

    # on fais un nouveau RubyLLM.chat.ask("prompt_LLM").content
    # on va chercher les ID des activitées approuvées
    # on va les ordonnées via le LLM dans la table de jointure en leurs donnant un ordre etc ...
    # qu'on enregistre dans Itinerary_item

    # dans un deuxième temps on passera sa en background job
  end

  private

  def recommendation_ok
    @recommendation_reviewed = User_trip_status.invitation_accepted
    @recommendation_accepted = Recommendation.accepted
    return if @recommendation_reviewed == 'true' && @recommendation_accepted == 'true'
  end
end

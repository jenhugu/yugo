class ItinerariesController < ApplicationController
  def show
    @trip = Trip.find(params[:trip_id])
    @itinerary = @trip.itineraries.find(params[:id])
  end

  def create
    # Déclencher quand la recommendation est validée
    # idee : if recommendation_reviewed = true && recommendation = accepted then LLM

    # on fais un nouveau RubyLLM.chat.ask("prompt_LLM").content
    # on itére sur chaque activitée de la recommendation approuvée pour leurs mettre une date slot etc ...
    # qu'on enregistre dans Itinerary_item

    # dans un deuxième temps on passera sa en background job
  end
end

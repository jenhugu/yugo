class ItinerariesController < ApplicationController
  def show
    @trip = Trip.find(params[:trip_id])
    @itinerary = @trip.itineraries.find(params[:id])
  end

  def create
    # Déclencher quand la recommendation est validée
    # LLM prompt pour creer l'itineraire en allant chercher les actvitiés
    # sa sera vie le LLM prompt que les dates etc... de Itinerary_item
    # seront cree
    # on ira chercher les activités via la recommendation
  end
end

class TripsController < ApplicationController
  def show
    @trip = Trip.find(params[:id])
  end

  def index
    # Récupérer tous les user_trip_statuses de l'utilisateur avec leurs trips
    user_trip_statuses = current_user.user_trip_statuses.includes(:trip)

    # Séparer les invitations pending et les trips acceptés
    pending_invitations = user_trip_statuses.where(invitation_accepted: false)
    accepted_trips = user_trip_statuses.where(invitation_accepted: true)

    # Combiner les deux : pending d'abord, puis acceptés
    @user_trip_statuses = pending_invitations + accepted_trips
  end

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.create(param[:id])
    @trip.save
  end

  def destroy
  end

  def edit
  end

  def update
  end
end

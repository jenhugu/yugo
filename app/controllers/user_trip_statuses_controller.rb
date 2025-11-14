class UserTripStatusesController < ApplicationController
  before_action :set_user_trip_status, only: [:accept_invitation]

  def accept_invitation
    if @user_trip_status.update(invitation_accepted: true)
      # Répondre en format Turbo Stream pour mise à jour AJAX
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "trip_card_#{@user_trip_status.id}",
            partial: "trips/trip_card",
            locals: { trip: @user_trip_status.trip }
          )
        end
        format.html do
          flash[:notice] = "You've successfully accepted this invitation"
          redirect_to trips_path
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "trip_card_#{@user_trip_status.id}",
            partial: "trips/trip_card_invitation",
            locals: { user_trip_status: @user_trip_status }
          )
        end
        format.html do
          flash[:alert] = "Something went wrong"
          redirect_to trips_path
        end
      end
    end
  end

  private

  def set_user_trip_status
    @user_trip_status = UserTripStatus.find(params[:id])
  end
end

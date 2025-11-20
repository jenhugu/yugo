class UserTripStatusesController < ApplicationController
  before_action :set_user_trip_status, only: [:accept_invitation, :fill_preferences]

  def accept_invitation
    if @user_trip_status.update(invitation_accepted: true)
      # Rediriger vers fill_preferences qui créera le form et affichera Step 1
      redirect_to fill_preferences_user_trip_status_path(@user_trip_status), notice: "You've successfully accepted this invitation", status: :see_other
    else
      flash[:alert] = "Something went wrong"
      redirect_to trips_path
    end
  end

  def fill_preferences
    # Créer le PreferencesForm s'il n'existe pas déjà
    @preferences_form = @user_trip_status.preferences_form || @user_trip_status.create_preferences_form!

    # Rendre la vue Step 1
    render "preferences_forms/step1"
  end

  private

  def set_user_trip_status
    @user_trip_status = UserTripStatus.find(params[:id])
  end
end

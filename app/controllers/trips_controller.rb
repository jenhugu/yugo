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
    @trip = Trip.new(trip_params)

    if @trip.save
      # Créer le UserTripStatus pour le créateur
      UserTripStatus.create!(
        trip: @trip,
        user: current_user,
        role: "creator",
        invitation_accepted: true,
        is_invited: false,
        form_filled: false,
        recommendation_reviewed: false
      )

      # Rediriger vers la page d'invitation
      redirect_to invite_trip_path(@trip)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def invite
    @trip = Trip.find(params[:id])
  end

  def add_participants
    @trip = Trip.find(params[:id])

    # Récupérer les emails et enlever les valeurs vides
    emails = params[:participant_emails].reject(&:blank?)

    emails.each do |email|
      # Trouver ou inviter l'utilisateur
      user = User.find_by(email: email)

      if user.nil?
        # Créer un user invité (sans envoyer d'email pour l'instant)
        # skip_invitation: true évite l'envoi d'email automatique car ActionMailer n'est pas configuré
        user = User.invite!(email: email, skip_invitation: true)
      end

      # Créer le UserTripStatus pour le participant
      # role: "participant" car ce n'est pas le créateur
      # invitation_accepted: false car l'invitation n'a pas encore été acceptée
      # is_invited: true car l'utilisateur a été invité
      UserTripStatus.create!(
        trip: @trip,
        user: user,
        role: "participant",
        invitation_accepted: false,
        is_invited: true,
        form_filled: false,
        recommendation_reviewed: false
      )
    end

    # Rediriger vers la page du trip (ou preferences plus tard)
    redirect_to trip_path(@trip), notice: "Participants invited successfully!"
  end

  def destroy
  end

  def edit
  end

  def update
  end

  private

  def trip_params
    params.require(:trip).permit(:name, :destination, :date)
  end
end

class PreferencesFormsController < ApplicationController
  before_action :set_trip_and_user_trip_status
  before_action :set_preferences_form, only: [:step1, :step2, :step3, :step4, :update, :show]

  def new
    # Vérifier si l'utilisateur a déjà un preferences_form pour ce trip
    @preferences_form = @user_trip_status.preferences_form || @user_trip_status.build_preferences_form
  end

  def create
    puts "\n\n===== STEP 1 PARAMS ====="
    pp params
    puts "=========================\n\n"

    @preferences_form = @user_trip_status.build_preferences_form

    # STEP 1 → Save interests JSON
    @preferences_form.interests = extract_interests(params[:preferences_form])

    if @preferences_form.save
      render :step2, locals: { preferences_form: @preferences_form }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def step1; end

  def step2; end
  def step3; end

  def step4
    render :step4, locals: { preferences_form: @preferences_form }
  end

def update
  # Preserve interests through steps
  if params[:preferences_form]
    params[:preferences_form][:interests] ||= @preferences_form.interests
  end

  case params[:step]
  when "1"
    if @preferences_form.update(preferences_form_params_step1)
      render :step2
    else
      render :step1, status: :unprocessable_entity
    end

  when "2"
    if @preferences_form.update(preferences_form_params_step2)
      render :step3
    else
      render :step2, status: :unprocessable_entity
    end

  when "3"
    if @preferences_form.update(preferences_form_params_step3)
      redirect_to step4_trip_preferences_form_path(@trip, @preferences_form)
    else
      render :step3, status: :unprocessable_entity
    end

  when "4"
    if @preferences_form.update(preferences_form_params_step4)
      # Marquer le formulaire comme rempli
      @preferences_form.user_trip_status.update(form_filled: true)

      # Déclencher la génération des recommendations si tous les formulaires sont remplis
      @preferences_form.reload
      trip = @preferences_form.user_trip_status&.trip

      if trip
        trip.generate_recommendations_if_ready
        redirect_to trip_path(trip), notice: "Congratulations, your preferences for this trip are now saved!", status: :see_other
      else
        redirect_to trips_path, alert: "Trip not found"
      end
    else
      render :step4, status: :unprocessable_entity
    end
  end
end


  def show
  end


  private

  def set_trip_and_user_trip_status
    @trip = Trip.find(params[:trip_id])
    @user_trip_status = @trip.user_trip_statuses.find_by(user: current_user)

    # Si l'utilisateur n'est pas participant de ce trip
    unless @user_trip_status
      redirect_to trips_path, alert: "You are not a participant of this trip"
    end
  end

  def set_preferences_form
    @preferences_form = PreferencesForm.find(params[:id])

    # Vérifier que le preferences_form appartient bien au trip et à l'utilisateur
    unless @preferences_form.user_trip_status == @user_trip_status
      redirect_to trips_path, alert: "Unauthorized"
    end
  end

  # Convert sliders to JSON for interests column
  def extract_interests(form_params)
    {
      culture:    form_params[:culture].to_i,
      food:       form_params[:food].to_i,
      nightlife:  form_params[:nightlife].to_i,
      nature:     form_params[:nature].to_i,
      shopping:   form_params[:shopping].to_i,
      sport:      form_params[:sport].to_i
    }
  end

  # STRONG PARAMS ------------------------------------------

  def preferences_form_params_step1
    interests_data = extract_interests(params[:preferences_form])
    { interests: interests_data }
  end

  def preferences_form_params_step2
    params.require(:preferences_form).permit(:travel_pace, :steps_per_day, :interests)
  end

  def preferences_form_params_step3
    params.require(:preferences_form).permit(:budget, :interests)
  end

  def preferences_form_params_step4
    params.require(:preferences_form).permit(:interests, activity_types: [])
  end
end

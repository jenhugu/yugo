class PreferencesFormsController < ApplicationController
  before_action :set_preferences_form, only: [:step2, :step3, :update, :show]

  # STEP 1 ( activity )
  def new
    @preferences_form = PreferencesForm.new
  end

  def create
    @preferences_form = PreferencesForm.new(preferences_form_params_step1)
    @preferences_form.user_trip_status = current_user_trip_status

    if @preferences_form.save
      render turbo_stream: turbo_stream.replace(
        "form_wrapper",
        partial: "preferences_forms/step2",
        locals: { preferences_form: @preferences_form }
      )
    else
      pp @preferences_form.errors.full_messages
      render :new, status: :unprocessable_content
    end
  end

  # STEP 2 ( pace )
  def step2
    render partial: "preferences_forms/step2", locals: { preferences_form: @preferences_form }
  end

  # STEP 3 (budget)
  def step3
    render partial: "preferences_forms/step3", locals: { preferences_form: @preferences_form }
  end

  # FINAL SAVE
  def update
    case params[:step]
    when "2"
      if @preferences_form.update(preferences_form_params_step2)
        render turbo_stream: turbo_stream.replace(
          "form_wrapper",
          partial: "preferences_forms/step3",
          locals: { preferences_form: @preferences_form }
        )
      else
        render :step2, status: :unprocessable_content
      end

    when "3"
      if @preferences_form.update(preferences_form_params_step3)
        redirect_to @preferences_form
      else
        render :step3, status: :unprocessable_content
      end
    end
  end

  def show; end

  private

  def set_preferences_form
    @preferences_form = PreferencesForm.find(params[:id])
  end

  def current_user_trip_status
    current_user.user_trip_statuses.last    # 👈 Logique par défaut
  end

  # Strong params
  def preferences_form_params_step1
    params.require(:preferences_form).permit(:culture, :food, :shopping, :nightlife, :nature, :sport)
  end

  def preferences_form_params_step2
    params.require(:preferences_form).permit(:travel_pace, :steps_per_day)
  end

  def preferences_form_params_step3
    params.require(:preferences_form).permit(:budget)
  end
end

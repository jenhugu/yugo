class PreferencesFormsController < ApplicationController
  before_action :set_preferences_form, only: [:step2, :step3, :step4,:update, :show]

  def new
    @preferences_form = PreferencesForm.new
  end

  def create
    @preferences_form = PreferencesForm.new(preferences_form_params_step1)
    @preferences_form.user_trip_status = current_user_trip_status

    if @preferences_form.save
      render :step2, locals: { preferences_form: @preferences_form }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def step2
    # step2.html.erb rendra _step2.html.erb automatiquement
  end

  def step3
    # step3.html.erb rendra _step3.html.erb automatiquement
  end

  def step4
    render :step4, locals: { preferences_form: @preferences_form }
  end


  def update
    case params[:step]

    when "2"
      if @preferences_form.update(preferences_form_params_step2)
        render :step3, locals: { preferences_form: @preferences_form }
      else
        render :step2, status: :unprocessable_entity
      end

    when "3"
      if @preferences_form.update(preferences_form_params_step3)
        redirect_to step4_preferences_form_path(@preferences_form)
      else
        render :step3, status: :unprocessable_entity
      end

    when "4"
      if @preferences_form.update(preferences_form_params_step4)
        redirect_to @preferences_form, status: :see_other
      else
        render :step4, status: :unprocessable_entity
      end

    end
  end

  def show
    # page recap plus tard
  end

  private

  def set_preferences_form
    @preferences_form = PreferencesForm.find(params[:id])
  end

  def current_user_trip_status
    current_user.user_trip_statuses.last
  end

  def preferences_form_params_step1
    params.require(:preferences_form).permit(:culture, :food, :nightlife, :nature, :shopping, :sport)
  end

  def preferences_form_params_step2
    params.require(:preferences_form).permit(:travel_pace, :steps_per_day)
  end

  def preferences_form_params_step3
    params.require(:preferences_form).permit(:budget)
  end

  def preferences_form_params_step4
    params.require(:preferences_form).permit(activity_types: [])
  end
end

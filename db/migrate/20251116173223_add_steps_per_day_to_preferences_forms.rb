class AddStepsPerDayToPreferencesForms < ActiveRecord::Migration[7.1]
  def change
    add_column :preferences_forms, :steps_per_day, :integer
  end
end

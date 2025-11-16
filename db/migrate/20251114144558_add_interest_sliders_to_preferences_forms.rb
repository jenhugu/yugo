class AddInterestSlidersToPreferencesForms < ActiveRecord::Migration[7.1]
  def change
    add_column :preferences_forms, :culture, :integer
    add_column :preferences_forms, :food, :integer
    add_column :preferences_forms, :shopping, :integer
    add_column :preferences_forms, :nightlife, :integer
    add_column :preferences_forms, :nature, :integer
    add_column :preferences_forms, :sport, :integer
  end
end

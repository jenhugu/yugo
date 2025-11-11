class AddKeysToModels < ActiveRecord::Migration[7.1]
  def change
    add_reference :preferences_forms, :user_trip_statuses, null: false, foreign_key: true
    add_reference :user_trip_statuses, :trips, null: false, foreign_key: true
  end
end

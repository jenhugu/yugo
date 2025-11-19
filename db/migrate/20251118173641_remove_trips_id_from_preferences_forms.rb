class RemoveTripsIdFromPreferencesForms < ActiveRecord::Migration[7.1]
  def change
    remove_column :preferences_forms, :trips_id, :bigint
  end
end

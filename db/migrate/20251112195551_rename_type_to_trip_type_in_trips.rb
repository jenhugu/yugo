class RenameTypeToTripTypeInTrips < ActiveRecord::Migration[7.1]
  def change
    rename_column :trips, :type, :trip_type
  end
end

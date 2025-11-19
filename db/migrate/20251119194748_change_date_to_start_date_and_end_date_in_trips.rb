class ChangeDateToStartDateAndEndDateInTrips < ActiveRecord::Migration[7.1]
  def change
    remove_column :trips, :date, :string
    add_column :trips, :start_date, :date
    add_column :trips, :end_date, :date
  end
end

class ChangeItineraryItemDateFormat < ActiveRecord::Migration[7.1]
  def change
    change_column :itinerary_items, :date, :date, using: 'date::date'
  end
end

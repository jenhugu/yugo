class ItineraryTableChange < ActiveRecord::Migration[7.1]
  def change
    change_column :itinerary_items, :time, :time, using: 'time::time'
    change_column :itinerary_items, :position, :integer, using: 'position::integer'
  end
end

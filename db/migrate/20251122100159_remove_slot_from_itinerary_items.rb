class RemoveSlotFromItineraryItems < ActiveRecord::Migration[7.1]
  def change
    remove_column :itinerary_items, :slot, :string
  end
end

class AddAllKeysToAllModels < ActiveRecord::Migration[7.1]
  def change
    add_reference :user_trip_statuses, :users, null: false, foreign_key: true
    add_reference :recommendations, :trips, null: false, foreign_key: true
    add_reference :recommendation_items, :activity_items, null: false, foreign_key: true
    add_reference :recommendation_items, :recommendations, null: false, foreign_key: true
    add_reference :activity_items, :itinerary_items, null: false, foreign_key: true
    add_reference :itinerary_items, :itineraries, null: false, foreign_key: true
    add_reference :itineraries, :trips, null: false, foreign_key: true
  end
end

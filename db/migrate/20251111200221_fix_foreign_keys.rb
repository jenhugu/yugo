class FixForeignKeys < ActiveRecord::Migration[7.1]
  def change

    # 1. Supprimer trips_id de preferences_forms (ne devrait avoir que user_trip_status_id)
    remove_foreign_key :preferences_forms, :trips

    # 2. Déplacer la foreign key de activity_items vers itinerary_items
    remove_foreign_key :activity_items, :itinerary_items
    remove_column :activity_items, :itinerary_items_id
    add_reference :itinerary_items, :activity_item, foreign_key: true

    # 3. Renommer toutes les foreign keys au singulier (convention Rails)
    # preferences_forms
    rename_column :preferences_forms, :user_trip_statuses_id, :user_trip_status_id

    # Supprimer trips_id de preferences_forms
    remove_column :preferences_forms, :trips_id, :integer
    # itineraries
    rename_column :itineraries, :trips_id, :trip_id

    # itinerary_items
    rename_column :itinerary_items, :itineraries_id, :itinerary_id

    # recommendation_items
    rename_column :recommendation_items, :activity_items_id, :activity_item_id
    rename_column :recommendation_items, :recommendations_id, :recommendation_id

    # recommendations
    rename_column :recommendations, :trips_id, :trip_id

    # user_trip_statuses
    rename_column :user_trip_statuses, :trips_id, :trip_id
    rename_column :user_trip_statuses, :users_id, :user_id
  end
end

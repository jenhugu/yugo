# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_11_11_165443) do
  create_table "activity_items", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "price"
    t.string "reservation_url"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "itinerary_items_id", null: false
    t.index ["itinerary_items_id"], name: "index_activity_items_on_itinerary_items_id"
  end

  create_table "itineraries", force: :cascade do |t|
    t.string "system_prompt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "trips_id", null: false
    t.index ["trips_id"], name: "index_itineraries_on_trips_id"
  end

  create_table "itinerary_items", force: :cascade do |t|
    t.string "date"
    t.string "slot"
    t.string "time"
    t.string "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "itineraries_id", null: false
    t.index ["itineraries_id"], name: "index_itinerary_items_on_itineraries_id"
  end

  create_table "preferences_forms", force: :cascade do |t|
    t.string "travel_pace"
    t.integer "budget"
    t.string "interests"
    t.string "activity_types"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "trips_id", null: false
    t.integer "user_trip_statuses_id", null: false
    t.index ["trips_id"], name: "index_preferences_forms_on_trips_id"
    t.index ["user_trip_statuses_id"], name: "index_preferences_forms_on_user_trip_statuses_id"
  end

  create_table "recommendation_items", force: :cascade do |t|
    t.boolean "like"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "activity_items_id", null: false
    t.integer "recommendations_id", null: false
    t.index ["activity_items_id"], name: "index_recommendation_items_on_activity_items_id"
    t.index ["recommendations_id"], name: "index_recommendation_items_on_recommendations_id"
  end

  create_table "recommendations", force: :cascade do |t|
    t.boolean "accepted"
    t.string "system_prompt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "trips_id", null: false
    t.index ["trips_id"], name: "index_recommendations_on_trips_id"
  end

  create_table "trips", force: :cascade do |t|
    t.string "name"
    t.string "destination"
    t.string "date"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_trip_statuses", force: :cascade do |t|
    t.binary "role"
    t.string "trip_status"
    t.boolean "is_invited"
    t.boolean "form_filled"
    t.boolean "recommendation_reviewed"
    t.boolean "invitation_accepted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "trips_id", null: false
    t.integer "users_id", null: false
    t.index ["trips_id"], name: "index_user_trip_statuses_on_trips_id"
    t.index ["users_id"], name: "index_user_trip_statuses_on_users_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "activity_items", "itinerary_items", column: "itinerary_items_id"
  add_foreign_key "itineraries", "trips", column: "trips_id"
  add_foreign_key "itinerary_items", "itineraries", column: "itineraries_id"
  add_foreign_key "preferences_forms", "trips", column: "trips_id"
  add_foreign_key "preferences_forms", "user_trip_statuses", column: "user_trip_statuses_id"
  add_foreign_key "recommendation_items", "activity_items", column: "activity_items_id"
  add_foreign_key "recommendation_items", "recommendations", column: "recommendations_id"
  add_foreign_key "recommendations", "trips", column: "trips_id"
  add_foreign_key "user_trip_statuses", "trips", column: "trips_id"
  add_foreign_key "user_trip_statuses", "users", column: "users_id"
end

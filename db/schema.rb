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

ActiveRecord::Schema[7.1].define(version: 2025_11_19_161312) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activity_items", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "price"
    t.string "reservation_url"
    t.string "activity_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "address"
    t.string "city"
    t.string "country"
    t.text "opening_hours"
    t.integer "duration"
    t.string "tagline"
  end

  create_table "itineraries", force: :cascade do |t|
    t.string "system_prompt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "trip_id", null: false
    t.index ["trip_id"], name: "index_itineraries_on_trip_id"
  end

  create_table "itinerary_items", force: :cascade do |t|
    t.date "date"
    t.string "slot"
    t.time "time"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "itinerary_id", null: false
    t.bigint "activity_item_id"
    t.index ["activity_item_id"], name: "index_itinerary_items_on_activity_item_id"
    t.index ["itinerary_id"], name: "index_itinerary_items_on_itinerary_id"
  end

  create_table "preferences_forms", force: :cascade do |t|
    t.string "travel_pace"
    t.integer "budget"
    t.string "interests"
    t.string "activity_types"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_trip_status_id", null: false
    t.integer "culture"
    t.integer "food"
    t.integer "shopping"
    t.integer "nightlife"
    t.integer "nature"
    t.integer "sport"
    t.integer "steps_per_day"
    t.index ["user_trip_status_id"], name: "index_preferences_forms_on_user_trip_status_id"
  end

  create_table "recommendation_items", force: :cascade do |t|
    t.boolean "like"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "activity_item_id", null: false
    t.bigint "recommendation_id", null: false
    t.index ["activity_item_id"], name: "index_recommendation_items_on_activity_item_id"
    t.index ["recommendation_id"], name: "index_recommendation_items_on_recommendation_id"
  end

  create_table "recommendations", force: :cascade do |t|
    t.boolean "accepted"
    t.string "system_prompt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "trip_id", null: false
    t.index ["trip_id"], name: "index_recommendations_on_trip_id"
  end

  create_table "trips", force: :cascade do |t|
    t.string "name"
    t.string "destination"
    t.string "date"
    t.string "trip_type"
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
    t.bigint "trip_id", null: false
    t.bigint "user_id", null: false
    t.index ["trip_id"], name: "index_user_trip_statuses_on_trip_id"
    t.index ["user_id"], name: "index_user_trip_statuses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "itineraries", "trips"
  add_foreign_key "itinerary_items", "activity_items"
  add_foreign_key "itinerary_items", "itineraries"
  add_foreign_key "preferences_forms", "user_trip_statuses"
  add_foreign_key "recommendation_items", "activity_items"
  add_foreign_key "recommendation_items", "recommendations"
  add_foreign_key "recommendations", "trips"
  add_foreign_key "user_trip_statuses", "trips"
  add_foreign_key "user_trip_statuses", "users"
end

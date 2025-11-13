# frozen_string_literal: true

class Trip < ApplicationRecord
  has_many :recommendations, dependent: :destroy
  has_many :itineraries, dependent: :destroy
  has_many :user_trip_statuses, dependent: :destroy
  has_many :users, through: :user_trip_statuses
  has_many :recommendation_items, through: :recommendations
  has_many :itinerary_items, through: :itineraries
  has_many :preferences_forms, through: :user_trip_statuses
end

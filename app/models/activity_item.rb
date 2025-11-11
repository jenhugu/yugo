class ActivityItem < ApplicationRecord
  has_many :recommendation_items
  has_many :itinerary_items
  has_many :itineraries, through: :itinerary_items
  has_many :recommendations, through: :recommendation_items
end

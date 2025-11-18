class ActivityItem < ApplicationRecord
  has_one_attached :image
  has_many :recommendation_items
  has_many :itinerary_items
  has_many :itineraries, through: :itinerary_items
  has_many :recommendations, through: :recommendation_items
end

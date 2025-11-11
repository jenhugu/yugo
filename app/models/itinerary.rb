class Itinerary < ApplicationRecord
  belongs_to :trip
  has_many :itinerary_items
  has_many :activity_items, through: :itinerary_items
end

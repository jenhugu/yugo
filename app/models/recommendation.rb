class Recommendation < ApplicationRecord
  belongs_to :trip
  has_many :recommendation_items
  has_many :activity_items, through: :recommendation_items
end

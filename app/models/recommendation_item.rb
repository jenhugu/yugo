class RecommendationItem < ApplicationRecord
  belongs_to :recommendation
  belongs_to :activity_item
  has_many :recommendation_votes, dependent: :destroy
  has_many :user_trip_statuses, through: :recommendation_votes
end

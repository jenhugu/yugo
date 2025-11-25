class RecommendationItem < ApplicationRecord
  belongs_to :recommendation
  belongs_to :activity_item
  has_many :recommendation_votes, dependent: :destroy
  has_many :user_trip_statuses, through: :recommendation_votes

  # Empêche qu'une même activité soit recommandée deux fois dans la même recommendation
  validates :activity_item_id, uniqueness: { scope: :recommendation_id, message: "is already in this recommendation" }
end

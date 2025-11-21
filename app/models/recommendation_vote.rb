# frozen_string_literal: true

class RecommendationVote < ApplicationRecord
  belongs_to :user_trip_status
  belongs_to :recommendation_item

  validates :like, inclusion: { in: [nil, true, false], allow_nil: true }
  validates :user_trip_status_id, uniqueness: { scope: :recommendation_item_id }
end

class UserTripStatus < ApplicationRecord
  belongs_to :trip
  belongs_to :user
  has_one :preferences_form, dependent: :destroy
  has_many :recommendation_votes, dependent: :destroy
  has_many :recommendation_items, through: :recommendation_votes
end

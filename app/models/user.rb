class User < ApplicationRecord
  has_many :user_trip_statuses, dependent: :destroy
  has_many :preferences_forms, through: :user_trip_statuses
  has_many :trips, through: :user_trip_statuses
end

class UserTripStatus < ApplicationRecord
  belongs_to :trip
  belongs_to :user
  has_one :preferences_form, dependent: :destroy
end

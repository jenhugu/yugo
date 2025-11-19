class PreferencesForm < ApplicationRecord
  belongs_to :user_trip_status

  serialize :activity_types, type: Array, coder: JSON

  # Always return an array (never nil)
  def activity_types
    super || []
  end
end

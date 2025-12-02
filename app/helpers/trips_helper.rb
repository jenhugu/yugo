module TripsHelper
  PARIS_TRIP_IMAGES = (1..6).map { |i| "Paris_trip_#{i}.jpg" }.freeze

  def pending_invitation?(user_trip_status)
    user_trip_status.invitation_accepted == false
  end

  def random_trip_image
    PARIS_TRIP_IMAGES.sample
  end
end

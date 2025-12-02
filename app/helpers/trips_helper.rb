module TripsHelper
  PARIS_TRIP_IMAGES = (1..6).map { |i| "trips/paris/Paris_trip_#{i}.jpg" }.freeze

  def pending_invitation?(user_trip_status)
    user_trip_status.invitation_accepted == false
  end

  def trip_image(trip)
    PARIS_TRIP_IMAGES[trip.id % PARIS_TRIP_IMAGES.size]
  end
end

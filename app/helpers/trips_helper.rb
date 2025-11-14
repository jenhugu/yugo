module TripsHelper
  def pending_invitation?(user_trip_status)
    user_trip_status.invitation_accepted == false
  end
end

# Clean database
puts "🧹 Cleaning database..."
RecommendationItem.destroy_all
ItineraryItem.destroy_all
Recommendation.destroy_all
Itinerary.destroy_all
PreferencesForm.destroy_all
UserTripStatus.destroy_all
ActivityItem.destroy_all
Trip.destroy_all
User.destroy_all

puts "👥 Creating users..."

# Create users
alice = User.create!(
  first_name: "Alice",
  last_name: "Johnson",
  email: "alice@yugo.com",
  password: "password123"
)

bob = User.create!(
  first_name: "Bob",
  last_name: "Smith",
  email: "bob@yugo.com",
  password: "password123"
)

charlie = User.create!(
  first_name: "Charlie",
  last_name: "Brown",
  email: "charlie@yugo.com",
  password: "password123"
)

diana = User.create!(
  first_name: "Diana",
  last_name: "Prince",
  email: "diana@yugo.com",
  password: "password123"
)

eve = User.create!(
  first_name: "Eve",
  last_name: "Martinez",
  email: "eve@yugo.com",
  password: "password123"
)

frank = User.create!(
  first_name: "Frank",
  last_name: "Wilson",
  email: "frank@yugo.com",
  password: "password123"
)

grace = User.create!(
  first_name: "Grace",
  last_name: "Lee",
  email: "grace@yugo.com",
  password: "password123"
)

henry = User.create!(
  first_name: "Henry",
  last_name: "Taylor",
  email: "henry@yugo.com",
  password: "password123"
)

puts "✅ Created #{User.count} users"

# ==============================================
# TRIP 1: All participants are pending invitation
# ==============================================
puts "\n🌍 Creating Trip 1: Weekend in London (All pending invitations)..."

trip1 = Trip.create!(
  name: "Weekend in London",
  destination: "London, UK",
  date: "2026-03-15",
  trip_type: "city_break"
)

# Alice is the creator (accepted invitation, hasn't filled form yet)
UserTripStatus.create!(
  user: alice,
  trip: trip1,
  role: "creator",
  trip_status: "pending_preferences",
  is_invited: true,
  invitation_accepted: true,
  form_filled: false,
  recommendation_reviewed: false
)

# Bob and Charlie are pending invitation
UserTripStatus.create!(
  user: bob,
  trip: trip1,
  role: "participant",
  trip_status: "pending_invitation",
  is_invited: true,
  invitation_accepted: false,
  form_filled: false,
  recommendation_reviewed: false
)

UserTripStatus.create!(
  user: charlie,
  trip: trip1,
  role: "participant",
  trip_status: "pending_invitation",
  is_invited: true,
  invitation_accepted: false,
  form_filled: false,
  recommendation_reviewed: false
)

puts "✅ Trip 1 created with #{trip1.user_trip_statuses.count} participants"

# ==============================================
# TRIP 2: Mixed statuses (The one in Paris)
# ==============================================
puts "\n🗼 Creating Trip 2: The one in Paris (Mixed statuses)..."

trip2 = Trip.create!(
  name: "The one in Paris",
  destination: "Paris, France",
  date: "2026-09-26",
  trip_type: "cultural"
)

# Diana is the creator (accepted, form filled)
uts_diana = UserTripStatus.create!(
  user: diana,
  trip: trip2,
  role: "creator",
  trip_status: "preferences_filled",
  is_invited: true,
  invitation_accepted: true,
  form_filled: true,
  recommendation_reviewed: false
)

# Diana's preferences
PreferencesForm.create!(
  user_trip_status: uts_diana,
  trips_id: trip2.id,
  travel_pace: "moderate",
  budget: 2000,
  interests: "museums, gastronomy, architecture",
  activity_types: "cultural, food"
)

# Eve accepted invitation but hasn't filled preferences
UserTripStatus.create!(
  user: eve,
  trip: trip2,
  role: "participant",
  trip_status: "pending_preferences",
  is_invited: true,
  invitation_accepted: true,
  form_filled: false,
  recommendation_reviewed: false
)

# Frank is pending invitation
UserTripStatus.create!(
  user: frank,
  trip: trip2,
  role: "participant",
  trip_status: "pending_invitation",
  is_invited: true,
  invitation_accepted: false,
  form_filled: false,
  recommendation_reviewed: false
)

puts "✅ Trip 2 created with #{trip2.user_trip_statuses.count} participants"

# ==============================================
# TRIP 3: All reviewing suggestions
# ==============================================
puts "\n🗾 Creating Trip 3: Summer in Tokyo (All reviewing suggestions)..."

trip3 = Trip.create!(
  name: "Summer in Tokyo",
  destination: "Tokyo, Japan",
  date: "2026-07-10",
  trip_type: "adventure"
)

# Grace is the creator (all steps done except review)
uts_grace = UserTripStatus.create!(
  user: grace,
  trip: trip3,
  role: "creator",
  trip_status: "reviewing_suggestions",
  is_invited: true,
  invitation_accepted: true,
  form_filled: true,
  recommendation_reviewed: false
)

PreferencesForm.create!(
  user_trip_status: uts_grace,
  trips_id: trip3.id,
  travel_pace: "intense",
  budget: 3500,
  interests: "temples, technology, anime, food",
  activity_types: "cultural, shopping, nightlife"
)

# Henry also reviewing suggestions
uts_henry = UserTripStatus.create!(
  user: henry,
  trip: trip3,
  role: "participant",
  trip_status: "reviewing_suggestions",
  is_invited: true,
  invitation_accepted: true,
  form_filled: true,
  recommendation_reviewed: false
)

PreferencesForm.create!(
  user_trip_status: uts_henry,
  trips_id: trip3.id,
  travel_pace: "moderate",
  budget: 3000,
  interests: "temples, sushi, gardens",
  activity_types: "cultural, food, nature"
)

# Create some activity items for recommendations
puts "\n🎯 Creating activity items..."

senso_ji = ActivityItem.create!(
  name: "Senso-ji Temple",
  description: "Tokyo's oldest temple in Asakusa",
  price: 0,
  reservation_url: "https://senso-ji.jp",
  activity_type: "cultural"
)

teamlab = ActivityItem.create!(
  name: "teamLab Borderless",
  description: "Digital art museum",
  price: 3200,
  reservation_url: "https://borderless.teamlab.art",
  activity_type: "art"
)

tsukiji = ActivityItem.create!(
  name: "Tsukiji Outer Market",
  description: "Famous fish market and street food",
  price: 2000,
  reservation_url: nil,
  activity_type: "food"
)

shibuya = ActivityItem.create!(
  name: "Shibuya Crossing Experience",
  description: "Iconic Tokyo crossing",
  price: 0,
  reservation_url: nil,
  activity_type: "sightseeing"
)

# Create recommendation for Trip 3
puts "📋 Creating recommendations..."

recommendation = Recommendation.create!(
  trip: trip3,
  accepted: false,
  system_prompt: "Generate cultural and food activities for Tokyo in summer"
)

RecommendationItem.create!(
  recommendation: recommendation,
  activity_item: senso_ji,
  like: nil
)

RecommendationItem.create!(
  recommendation: recommendation,
  activity_item: teamlab,
  like: nil
)

RecommendationItem.create!(
  recommendation: recommendation,
  activity_item: tsukiji,
  like: nil
)

RecommendationItem.create!(
  recommendation: recommendation,
  activity_item: shibuya,
  like: nil
)

puts "✅ Trip 3 created with #{trip3.user_trip_statuses.count} participants and #{recommendation.recommendation_items.count} recommendations"

# Summary
puts "\n" + "="*50
puts "🎉 SEED COMPLETED!"
puts "="*50
puts "\n📊 Summary:"
puts "  👥 Users: #{User.count}"
puts "  🌍 Trips: #{Trip.count}"
puts "  📝 User Trip Statuses: #{UserTripStatus.count}"
puts "  📋 Preferences Forms: #{PreferencesForm.count}"
puts "  🎯 Activity Items: #{ActivityItem.count}"
puts "  💡 Recommendations: #{Recommendation.count}"
puts "  ⭐ Recommendation Items: #{RecommendationItem.count}"
puts "\n✨ You can now test your trips:"
puts "  • Trip 1 (#{trip1.name}): ID #{trip1.id} - All pending invitations"
puts "  • Trip 2 (#{trip2.name}): ID #{trip2.id} - Mixed statuses"
puts "  • Trip 3 (#{trip3.name}): ID #{trip3.id} - All reviewing suggestions"
puts "="*50

# Clean database
puts "🧹 Cleaning database..."

# Disable job enqueueing during seed
original_adapter = ActiveJob::Base.queue_adapter
ActiveJob::Base.queue_adapter = :inline

# Purge attachments from Cloudinary before destroying records
puts "☁️  Purging attachments from Cloudinary..."
User.find_each do |user|
  user.avatar.purge if user.avatar.attached?
end

ActivityItem.find_each do |item|
  item.image.purge if item.image.attached?
end

puts "✅ Attachments purged from Cloudinary"

RecommendationVote.destroy_all
RecommendationItem.destroy_all
ItineraryItem.destroy_all
Recommendation.destroy_all
Itinerary.destroy_all
PreferencesForm.destroy_all
UserTripStatus.destroy_all
ActivityItem.destroy_all
Trip.destroy_all
User.destroy_all

puts "👥 Creating users with avatars..."

# Create Friends characters as users
rachel = User.create!(
  first_name: "Rachel",
  last_name: "Green",
  email: "rachel@yugo.com",
  password: "password123"
)
rachel.avatar.attach(io: File.open(Rails.root.join('app/assets/images/Rachel-avatar.png')), filename: 'Rachel-avatar.png', content_type: 'image/png')

monica = User.create!(
  first_name: "Monica",
  last_name: "Geller",
  email: "monica@yugo.com",
  password: "password123"
)
monica.avatar.attach(io: File.open(Rails.root.join('app/assets/images/Monica-avatar.png')), filename: 'Monica-avatar.png', content_type: 'image/png')

phoebe = User.create!(
  first_name: "Phoebe",
  last_name: "Buffay",
  email: "phoebe@yugo.com",
  password: "password123"
)
phoebe.avatar.attach(io: File.open(Rails.root.join('app/assets/images/Phoebe-avatar.png')), filename: 'Phoebe-avatar.png', content_type: 'image/png')

ross = User.create!(
  first_name: "Ross",
  last_name: "Geller",
  email: "ross@yugo.com",
  password: "password123"
)
ross.avatar.attach(io: File.open(Rails.root.join('app/assets/images/Ross_avatar.png')), filename: 'Ross_avatar.png', content_type: 'image/png')

chandler = User.create!(
  first_name: "Chandler",
  last_name: "Bing",
  email: "chandler@yugo.com",
  password: "password123"
)
chandler.avatar.attach(io: File.open(Rails.root.join('app/assets/images/Chandler-avatar.png')), filename: 'Chandler-avatar.png', content_type: 'image/png')

joey = User.create!(
  first_name: "Joey",
  last_name: "Tribbiani",
  email: "joey@yugo.com",
  password: "password123"
)
joey.avatar.attach(io: File.open(Rails.root.join('app/assets/images/Joey-avatar.png')), filename: 'Joey-avatar.png', content_type: 'image/png')

vincent = User.create!(
  first_name: "Vincent",
  last_name: "Horo",
  email: "vincent@yugo.com",
  password: "password123"
)
vincent.avatar.attach(io: File.open(Rails.root.join('app/assets/images/vincent_avatar.jpg')), filename: 'vincent_avatar.jpg', content_type: 'image/jpeg')

puts "✅ Created #{User.count} users with avatars"

# Create activity items for recommendations
puts "\n🎯 Creating Paris activity items..."

# ========================================
# 🍽️ RESTAURANTS & CAFÉS (30 items)
# ========================================

puts "Creating restaurants and cafés..."

ActivityItem.create!(
  name: "Le Comptoir du Relais",
  description: "Emblematic Parisian bistro serving traditional French cuisine in a lively atmosphere. Reservation essential.",
  price: 45,
  reservation_url: "https://hotel-paris-relais-saint-germain.com",
  activity_type: "restaurant",
  address: "9 Carrefour de l'Odéon, 75006 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sat: 12:00 PM-2:30 PM, 7:00 PM-11:00 PM",
  duration: 120,
  tagline: "The Parisian insider's favorite bistro",
  latitude: 48.8516,
  longitude: 2.3388
)

ActivityItem.create!(
  name: "Breizh Café",
  description: "Best Breton crepes in Paris, featuring organic products and artisanal cider. Warm and authentic atmosphere.",
  price: 18,
  reservation_url: "https://breizhcafe.com",
  activity_type: "restaurant",
  address: "109 Rue Vieille du Temple, 75003 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Wed-Sun: 11:30 AM-11:00 PM",
  duration: 90,
  tagline: "Brittany in the heart of Le Marais",
  latitude: 48.8631,
  longitude: 2.3612
)

ActivityItem.create!(
  name: "L'As du Fallafel",
  description: "Jewish Quarter institution serving the best falafels in Paris since 1979. Expect a queue, but it's worth the wait!",
  price: 8,
  reservation_url: "",
  activity_type: "restaurant",
  address: "34 Rue des Rosiers, 75004 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Sun-Thu: 11:00 AM-11:00 PM, Fri: 11:00 AM-6:00 PM",
  duration: 45,
  tagline: "Le Marais's legendary falafel",
  latitude: 48.8571,
  longitude: 2.3579
)

ActivityItem.create!(
  name: "Café de Flore",
  description: "Historic Saint-Germain café, a gathering place for intellectuals and artists since 1887. Beautifully preserved Art Deco atmosphere.",
  price: 12,
  reservation_url: "https://cafedeflore.fr",
  activity_type: "cafe",
  address: "172 Boulevard Saint-Germain, 75006 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 7:00 AM-1:30 AM",
  duration: 60,
  tagline: "Where Sartre wrote his manifestos",
  latitude: 48.8540,
  longitude: 2.3325
)

ActivityItem.create!(
  name: "Septime",
  description: "Modern gastronomic restaurant with inventive cuisine and seasonal products. Michelin star, relaxed atmosphere.",
  price: 85,
  reservation_url: "https://septime-charonne.fr",
  activity_type: "restaurant",
  address: "80 Rue de Charonne, 75011 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Fri: 12:00 PM-2:00 PM, 7:30 PM-10:00 PM",
  duration: 150,
  tagline: "The new guard of Parisian gastronomy",
  latitude: 48.8534,
  longitude: 2.3803
)

ActivityItem.create!(
  name: "Angelina",
  description: "Belle Époque tea salon famous for its smooth hot chocolate and legendary Mont-Blanc. Sumptuous decor.",
  price: 15,
  reservation_url: "https://angelina-paris.fr",
  activity_type: "cafe",
  address: "226 Rue de Rivoli, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 7:30 AM-7:00 PM",
  duration: 75,
  tagline: "The hot chocolate warming Paris since 1903",
  latitude: 48.8650,
  longitude: 2.3286
)

ActivityItem.create!(
  name: "Chez Janou",
  description: "Authentic Provençal bistro with shaded terrace and over 90 pastis at the counter. Southern atmosphere guaranteed.",
  price: 28,
  reservation_url: "https://chezjanou.com",
  activity_type: "restaurant",
  address: "2 Rue Roger Verlomme, 75003 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 12:00 PM-3:00 PM, 7:00 PM-11:30 PM",
  duration: 120,
  tagline: "A corner of Provence in Le Marais",
  latitude: 48.8553,
  longitude: 2.3667
)

ActivityItem.create!(
  name: "Pink Mamma",
  description: "XXL Italian trattoria spanning 4 floors with spectacular plant decor. Fresh pasta and wood-fired pizzas.",
  price: 25,
  reservation_url: "https://bigmammagroup.com/fr/trattorias/pink-mamma",
  activity_type: "restaurant",
  address: "20bis Rue de Douai, 75009 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 12:00 PM-2:30 PM, 6:30 PM-11:00 PM",
  duration: 105,
  tagline: "Italy at full size in Pigalle",
  latitude: 48.8819,
  longitude: 2.3330
)

ActivityItem.create!(
  name: "Le Relais de l'Entrecôte",
  description: "Cult restaurant with no menu: steak-fries with secret sauce, walnut salad as appetizer. Simple and delicious, no reservation.",
  price: 30,
  reservation_url: "",
  activity_type: "restaurant",
  address: "15 Rue Marbeuf, 75008 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 12:00 PM-2:30 PM, 7:00 PM-11:00 PM",
  duration: 90,
  tagline: "One option, zero disappointment",
  latitude: 48.8702,
  longitude: 2.3045
)

ActivityItem.create!(
  name: "Café Kitsuné",
  description: "Minimalist Japanese coffee shop serving specialty coffees and fusion pastries. Refined design, exceptional products.",
  price: 6,
  reservation_url: "https://cafekitsune.com",
  activity_type: "cafe",
  address: "51 Galerie de Montpensier, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 9:00 AM-6:00 PM",
  duration: 45,
  tagline: "The art of Japanese coffee",
  latitude: 48.8636,
  longitude: 2.3370
)

ActivityItem.create!(
  name: "Bouillon Chartier",
  description: "Historic bouillon from 1896 with listed decor. Traditional French cuisine at small prices in a Belle Époque setting.",
  price: 18,
  reservation_url: "",
  activity_type: "restaurant",
  address: "7 Rue du Faubourg Montmartre, 75009 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 11:30 AM-10:00 PM",
  duration: 90,
  tagline: "Eat like it's 1900 without breaking the bank",
  latitude: 48.8718,
  longitude: 2.3437
)

ActivityItem.create!(
  name: "Frenchie",
  description: "Modern bistro by Gregory Marchand, pioneer of Parisian bistronomie. Creative cuisine with local products.",
  price: 60,
  reservation_url: "https://frenchie-restaurant.com",
  activity_type: "restaurant",
  address: "5 Rue du Nil, 75002 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sat: 7:00 PM-10:00 PM",
  duration: 135,
  tagline: "The bistro that revolutionized the Parisian scene",
  latitude: 48.8664,
  longitude: 2.3473
)

ActivityItem.create!(
  name: "Holybelly",
  description: "Cult Anglo-Saxon brunch with fluffy pancakes and specialty coffee. Lines start at opening on weekends.",
  price: 22,
  reservation_url: "",
  activity_type: "cafe",
  address: "19 Rue Lucien Sampaix, 75010 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Wed-Fri: 9:00 AM-5:00 PM, Sat-Sun: 9:00 AM-6:00 PM",
  duration: 90,
  tagline: "The brunch worth waking up for on weekends",
  latitude: 48.8719,
  longitude: 2.3608
)

ActivityItem.create!(
  name: "Le Train Bleu",
  description: "Mythical Gare de Lyon restaurant with Second Empire decor listed as historic monument. French gastronomic cuisine.",
  price: 75,
  reservation_url: "https://le-train-bleu.com",
  activity_type: "restaurant",
  address: "Place Louis-Armand, Gare de Lyon, 75012 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 11:30 AM-3:00 PM, 7:00 PM-11:00 PM",
  duration: 150,
  tagline: "Travel through time without leaving Paris",
  latitude: 48.8448,
  longitude: 2.3735
)

ActivityItem.create!(
  name: "Miznon",
  description: "Creative Israeli street food in an electric atmosphere. Generously filled pitas, wood-roasted vegetables.",
  price: 14,
  reservation_url: "",
  activity_type: "restaurant",
  address: "22 Rue des Ecouffes, 75004 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 12:00 PM-11:00 PM",
  duration: 60,
  tagline: "Tel Aviv arrives in Le Marais",
  latitude: 48.8563,
  longitude: 2.3565
)

ActivityItem.create!(
  name: "La Jacobine",
  description: "Cosy literary tea salon with exceptional selection of teas from around the world. Perfect for afternoon reading.",
  price: 8,
  reservation_url: "",
  activity_type: "cafe",
  address: "59-61 Rue Saint-André des Arts, 75006 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 11:00 AM-7:00 PM",
  duration: 90,
  tagline: "The secret haven of tea and book lovers",
  latitude: 48.8531,
  longitude: 2.3418
)

ActivityItem.create!(
  name: "Chez L'Ami Jean",
  description: "Generous Basque bistro serving hearty dishes and friendly atmosphere. Rice pudding is legendary.",
  price: 50,
  reservation_url: "https://lamijean.fr",
  activity_type: "restaurant",
  address: "27 Rue Malar, 75007 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sat: 12:00 PM-2:00 PM, 7:00 PM-11:00 PM",
  duration: 120,
  tagline: "Sharing and generosity the Basque way",
  latitude: 48.8598,
  longitude: 2.3027
)

ActivityItem.create!(
  name: "Claus",
  description: "Upscale breakfast and brunch with artisanal products. Homemade jams and exceptional pastries.",
  price: 20,
  reservation_url: "https://clausparis.com",
  activity_type: "cafe",
  address: "14 Rue Jean-Jacques Rousseau, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 8:30 AM-5:00 PM",
  duration: 75,
  tagline: "Luxury breakfast experience",
  latitude: 48.8627,
  longitude: 2.3428
)

ActivityItem.create!(
  name: "Le Baratin",
  description: "Cult neighborhood bistro in Belleville. Inventive market cuisine, exceptional wine list, no credit cards.",
  price: 35,
  reservation_url: "",
  activity_type: "restaurant",
  address: "3 Rue Jouye-Rouve, 75020 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sat: 12:00 PM-2:30 PM, 7:30 PM-11:00 PM",
  duration: 120,
  tagline: "The secret bistro of true Parisians",
  latitude: 48.8711,
  longitude: 2.3880
)

ActivityItem.create!(
  name: "Ellsworth",
  description: "American-Parisian restaurant with weekend brunch and creative weekday dinner. Relaxed and warm atmosphere.",
  price: 28,
  reservation_url: "https://ellsworthparis.com",
  activity_type: "restaurant",
  address: "34 Rue de Richelieu, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sat: 12:00 PM-3:00 PM, 6:00 PM-11:00 PM, Sun: 11:00 AM-4:00 PM",
  duration: 105,
  tagline: "Brooklyn meets Paris",
  latitude: 48.8671,
  longitude: 2.3369
)

ActivityItem.create!(
  name: "Le Consulat",
  description: "Historic Montmartre café with picturesque terrace. Unobstructed view of Place du Tertre, bohemian atmosphere.",
  price: 10,
  reservation_url: "",
  activity_type: "cafe",
  address: "18 Rue Norvins, 75018 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 8:00 AM-1:00 AM",
  duration: 60,
  tagline: "Montmartre's postcard-perfect café",
  latitude: 48.8867,
  longitude: 2.3408
)

ActivityItem.create!(
  name: "Bistrot Paul Bert",
  description: "Archetype of traditional Parisian bistro. Aged meats, hand-cut tartare, retro decor unchanged for decades.",
  price: 38,
  reservation_url: "https://bistrotpaulbert.com",
  activity_type: "restaurant",
  address: "18 Rue Paul Bert, 75011 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sat: 12:00 PM-2:00 PM, 7:30 PM-11:00 PM",
  duration: 120,
  tagline: "The bistro in all its splendor",
  latitude: 48.8508,
  longitude: 2.3883
)

ActivityItem.create!(
  name: "KB CaféShop",
  description: "Australian coffee shop pioneer of flat white in Paris. Healthy brunch, excellent coffee and relaxed atmosphere.",
  price: 15,
  reservation_url: "https://kbcafeshop.com",
  activity_type: "cafe",
  address: "53 Avenue Trudaine, 75009 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Fri: 8:00 AM-5:00 PM, Sat-Sun: 9:00 AM-6:00 PM",
  duration: 75,
  tagline: "Australian coffee culture in Pigalle",
  latitude: 48.8815,
  longitude: 2.3454
)

ActivityItem.create!(
  name: "Le Chateaubriand",
  description: "Avant-garde neo-bistro by Iñaki Aizpitarte. Daily surprise menu, boundless creativity.",
  price: 70,
  reservation_url: "",
  activity_type: "restaurant",
  address: "129 Avenue Parmentier, 75011 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sat: 7:00 PM-10:00 PM",
  duration: 150,
  tagline: "Culinary boldness made in Paris",
  latitude: 48.8668,
  longitude: 2.3771
)

ActivityItem.create!(
  name: "Carette",
  description: "Chic pastry shop and tea salon overlooking Place des Vosges. Macarons, eclairs and Viennese chocolate in elegant setting.",
  price: 12,
  reservation_url: "https://carette-paris.fr",
  activity_type: "cafe",
  address: "25 Place des Vosges, 75003 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 8:00 AM-7:00 PM",
  duration: 60,
  tagline: "Parisian sweetness in the most beautiful square",
  latitude: 48.8555,
  longitude: 2.3657
)

ActivityItem.create!(
  name: "Nanashi",
  description: "Authentic Japanese bento bar with homemade gyozas and balanced bentos. Lunch queue but quick service.",
  price: 14,
  reservation_url: "",
  activity_type: "restaurant",
  address: "31 Rue de Paradis, 75010 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sat: 12:00 PM-3:00 PM, 7:00 PM-10:30 PM",
  duration: 45,
  tagline: "Authentic Japan without the fuss",
  latitude: 48.8749,
  longitude: 2.3508
)

ActivityItem.create!(
  name: "Le Servan",
  description: "Neo-bistro by sisters Levha blending French cuisine and Asian influences. Exceptional natural wine pairings.",
  price: 45,
  reservation_url: "https://leservan.com",
  activity_type: "restaurant",
  address: "32 Rue Saint-Maur, 75011 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sat: 12:00 PM-2:30 PM, 7:00 PM-10:30 PM",
  duration: 135,
  tagline: "Franco-Asian fusion by two talented sisters",
  latitude: 48.8636,
  longitude: 2.3807
)

ActivityItem.create!(
  name: "Les Deux Magots",
  description: "Mythical Saint-Germain literary café frequented by Hemingway and Sartre. Iconic terrace, renowned hot chocolate.",
  price: 13,
  reservation_url: "https://lesdeuxmagots.fr",
  activity_type: "cafe",
  address: "6 Place Saint-Germain des Prés, 75006 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 7:30 AM-1:00 AM",
  duration: 75,
  tagline: "Where existentialists remade the world",
  latitude: 48.8541,
  longitude: 2.3332
)

ActivityItem.create!(
  name: "Chambelland",
  description: "100% gluten-free bakery pioneer in Paris. Sourdough bread, pastries and sandwiches for celiacs and food lovers.",
  price: 8,
  reservation_url: "https://chambelland.com",
  activity_type: "cafe",
  address: "14 Rue Ternaux, 75011 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sat: 8:00 AM-7:00 PM, Sun: 8:00 AM-3:00 PM",
  duration: 30,
  tagline: "Gluten-free finally delicious",
  latitude: 48.8618,
  longitude: 2.3740
)

ActivityItem.create!(
  name: "Astier",
  description: "Traditional 11th arrondissement bistro with unlimited cheese platter. Remarkable wine cellar, authentic and warm atmosphere.",
  price: 35,
  reservation_url: "",
  activity_type: "restaurant",
  address: "44 Rue Jean-Pierre Timbaud, 75011 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Fri: 12:00 PM-2:00 PM, 7:30 PM-10:30 PM",
  duration: 120,
  tagline: "All-you-can-eat cheese worth the detour",
  latitude: 48.8658,
  longitude: 2.3756
)

# ========================================
# 🎨 MUSÉES & GALERIES (25 items)
# ========================================

puts "Creating museums and galleries..."

ActivityItem.create!(
  name: "Musée d'Orsay",
  description: "Former train station transformed into a museum housing the world's largest collection of Impressionist art. Monet, Renoir, Van Gogh...",
  price: 16,
  reservation_url: "https://www.musee-orsay.fr",
  activity_type: "museum",
  address: "1 Rue de la Légion d'Honneur, 75007 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sun: 9:30 AM-6:00 PM (Thu until 9:45 PM)",
  duration: 180,
  tagline: "Impressionism in a majestic train station",
  latitude: 48.8600,
  longitude: 2.3266
)

ActivityItem.create!(
  name: "Musée Rodin",
  description: "Historic mansion and sculpture garden showcasing Rodin's masterpieces. The Thinker, The Kiss in an enchanting setting.",
  price: 13,
  reservation_url: "https://www.musee-rodin.fr",
  activity_type: "museum",
  address: "77 Rue de Varenne, 75007 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sun: 10:00 AM-6:30 PM",
  duration: 120,
  tagline: "Monumental sculptures in a secret garden",
  latitude: 48.8554,
  longitude: 2.3158
)

ActivityItem.create!(
  name: "Centre Pompidou",
  description: "Revolutionary architecture housing Europe's largest modern art museum. Picasso, Matisse, Kandinsky and panoramic views.",
  price: 15,
  reservation_url: "https://www.centrepompidou.fr",
  activity_type: "museum",
  address: "Place Georges-Pompidou, 75004 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Wed-Mon: 11:00 AM-9:00 PM",
  duration: 150,
  tagline: "Modern art in a viewing machine",
  latitude: 48.8607,
  longitude: 2.3522
)

ActivityItem.create!(
  name: "Musée de l'Orangerie",
  description: "Intimate setting for Monet's Water Lilies and Walter-Guillaume collection. Immersive experience in late Impressionism.",
  price: 12,
  reservation_url: "https://www.musee-orangerie.fr",
  activity_type: "museum",
  address: "Jardin des Tuileries, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Wed-Mon: 9:00 AM-6:00 PM",
  duration: 90,
  tagline: "Dive into Monet's Water Lilies",
  latitude: 48.8638,
  longitude: 2.3225
)

ActivityItem.create!(
  name: "Musée Picasso",
  description: "World's largest public Picasso collection in a magnificent Marais mansion. All periods of the artist's work.",
  price: 14,
  reservation_url: "https://www.museepicassoparis.fr",
  activity_type: "museum",
  address: "5 Rue de Thorigny, 75003 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Fri: 10:30 AM-6:00 PM, Sat-Sun: 9:30 AM-6:00 PM",
  duration: 120,
  tagline: "Picasso like you've never seen before",
  latitude: 48.8597,
  longitude: 2.3622
)

ActivityItem.create!(
  name: "Musée Jacquemart-André",
  description: "Second Empire mansion with exceptional private collection. Fragonard, Botticelli in sumptuous decor.",
  price: 17,
  reservation_url: "https://www.musee-jacquemart-andre.com",
  activity_type: "museum",
  address: "158 Boulevard Haussmann, 75008 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 10:00 AM-6:00 PM (Mon until 8:30 PM)",
  duration: 105,
  tagline: "Live like a 19th-century banker",
  latitude: 48.8752,
  longitude: 2.3109
)

ActivityItem.create!(
  name: "Atelier des Lumières",
  description: "Digital immersive experience projecting artworks across 3000 sq meters. Breathtaking light and sound show.",
  price: 17,
  reservation_url: "https://www.atelier-lumieres.com",
  activity_type: "art",
  address: "38 Rue Saint-Maur, 75011 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 10:00 AM-6:00 PM (Sat until 10:00 PM)",
  duration: 75,
  tagline: "Step into giant paintings",
  latitude: 48.8614,
  longitude: 2.3804
)

ActivityItem.create!(
  name: "Musée Carnavalet",
  description: "History of Paris from prehistoric times to present day in two restored mansions. Free and fascinating.",
  price: 0,
  reservation_url: "https://www.carnavalet.paris.fr",
  activity_type: "museum",
  address: "23 Rue de Sévigné, 75003 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sun: 10:00 AM-6:00 PM",
  duration: 135,
  tagline: "Paris's history told by Paris itself",
  latitude: 48.8575,
  longitude: 2.3627
)

ActivityItem.create!(
  name: "Palais de Tokyo",
  description: "Experimental contemporary art center with cutting-edge exhibitions. Brutalist architecture, bold programming.",
  price: 12,
  reservation_url: "https://palaisdetokyo.com",
  activity_type: "art",
  address: "13 Avenue du Président Wilson, 75116 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Wed-Mon: 12:00 PM-10:00 PM",
  duration: 120,
  tagline: "Art that challenges certainties",
  latitude: 48.8642,
  longitude: 2.2974
)

ActivityItem.create!(
  name: "Musée Marmottan Monet",
  description: "Intimate collection devoted to Impressionism with world's largest Monet collection, including Impression Sunrise.",
  price: 14,
  reservation_url: "https://www.marmottan.fr",
  activity_type: "museum",
  address: "2 Rue Louis Boilly, 75016 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sun: 10:00 AM-6:00 PM (Thu until 9:00 PM)",
  duration: 105,
  tagline: "Monet's secret collection away from crowds",
  latitude: 48.8600,
  longitude: 2.2667
)

ActivityItem.create!(
  name: "Petit Palais",
  description: "Paris City Museum of Fine Arts with collections from Antiquity to 20th century. Peaceful inner garden, free admission.",
  price: 0,
  reservation_url: "https://www.petitpalais.paris.fr",
  activity_type: "museum",
  address: "Avenue Winston Churchill, 75008 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sun: 10:00 AM-6:00 PM",
  duration: 120,
  tagline: "The palace of free art",
  latitude: 48.8660,
  longitude: 2.3140
)

ActivityItem.create!(
  name: "Fondation Louis Vuitton",
  description: "Spectacular Frank Gehry building housing modern and contemporary art. Iconic architecture in the Bois de Boulogne.",
  price: 16,
  reservation_url: "https://www.fondationlouisvuitton.fr",
  activity_type: "art",
  address: "8 Avenue du Mahatma Gandhi, 75116 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon,Wed-Thu: 11:00 AM-8:00 PM, Fri: 11:00 AM-9:00 PM, Sat-Sun: 10:00 AM-8:00 PM",
  duration: 150,
  tagline: "The spacecraft of contemporary art",
  latitude: 48.8768,
  longitude: 2.2650
)

ActivityItem.create!(
  name: "Musée des Arts Décoratifs",
  description: "Design, fashion and advertising from 1200 to present day. Exceptional collection of art objects and crafts at the Louvre.",
  price: 14,
  reservation_url: "https://madparis.fr",
  activity_type: "museum",
  address: "107 Rue de Rivoli, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sun: 11:00 AM-6:00 PM",
  duration: 120,
  tagline: "The history of design and fashion",
  latitude: 48.8627,
  longitude: 2.3328
)

ActivityItem.create!(
  name: "Musée du Quai Branly",
  description: "Arts and civilizations from Africa, Asia, Oceania and Americas. Jean Nouvel architecture with spectacular vertical garden.",
  price: 12,
  reservation_url: "https://www.quaibranly.fr",
  activity_type: "museum",
  address: "37 Quai Jacques Chirac, 75007 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue,Wed,Sun: 10:30 AM-7:00 PM, Thu-Sat: 10:30 AM-10:00 PM",
  duration: 135,
  tagline: "A world tour of cultures",
  latitude: 48.8612,
  longitude: 2.2978
)

ActivityItem.create!(
  name: "Musée Nissim de Camondo",
  description: "Historic mansion frozen in time with intact 18th-century furniture. Intimate atmosphere of an inhabited home.",
  price: 12,
  reservation_url: "https://madparis.fr/nissim-de-camondo",
  activity_type: "museum",
  address: "63 Rue de Monceau, 75008 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Wed-Sun: 10:00 AM-5:30 PM",
  duration: 90,
  tagline: "Travel back in time in an 18th-century apartment",
  latitude: 48.8795,
  longitude: 2.3115
)

ActivityItem.create!(
  name: "Musée de la Chasse et de la Nature",
  description: "Contemporary cabinet of curiosities blending art and taxidermy. Fascinating collections in a Baroque mansion.",
  price: 10,
  reservation_url: "https://www.chassenature.org",
  activity_type: "museum",
  address: "62 Rue des Archives, 75003 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sun: 11:00 AM-6:00 PM",
  duration: 90,
  tagline: "The 21st-century cabinet of curiosities",
  latitude: 48.8610,
  longitude: 2.3570
)

ActivityItem.create!(
  name: "Musée Cognacq-Jay",
  description: "Intimate 18th-century collection in a Marais mansion. Fragonard, Boucher, refined furniture. Free and little-known.",
  price: 0,
  reservation_url: "https://www.museecognacqjay.paris.fr",
  activity_type: "museum",
  address: "8 Rue Elzévir, 75003 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sun: 10:00 AM-6:00 PM",
  duration: 75,
  tagline: "The 18th century in intimate detail",
  latitude: 48.8590,
  longitude: 2.3618
)

ActivityItem.create!(
  name: "Galerie Perrotin",
  description: "Major contemporary art gallery representing international artists. Ambitious exhibitions, free admission.",
  price: 0,
  reservation_url: "https://www.perrotin.com",
  activity_type: "art",
  address: "76 Rue de Turenne, 75003 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sat: 11:00 AM-7:00 PM",
  duration: 60,
  tagline: "The world's artistic avant-garde",
  latitude: 48.8605,
  longitude: 2.3630
)

ActivityItem.create!(
  name: "Musée Bourdelle",
  description: "Studio-museum of sculptor Antoine Bourdelle. Hidden gardens with monumental sculptures, preserved studio atmosphere.",
  price: 0,
  reservation_url: "https://www.bourdelle.paris.fr",
  activity_type: "museum",
  address: "18 Rue Antoine Bourdelle, 75015 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sun: 10:00 AM-6:00 PM",
  duration: 90,
  tagline: "A master sculptor's secret studio",
  latitude: 48.8428,
  longitude: 2.3189
)

ActivityItem.create!(
  name: "Cité de l'Architecture",
  description: "World's largest architecture center with monumental casts and modern gallery. Eiffel Tower view from the café.",
  price: 9,
  reservation_url: "https://www.citedelarchitecture.fr",
  activity_type: "museum",
  address: "1 Place du Trocadéro, 75116 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Wed-Mon: 11:00 AM-7:00 PM",
  duration: 120,
  tagline: "French architecture at full scale",
  latitude: 48.8630,
  longitude: 2.2875
)

ActivityItem.create!(
  name: "Musée Gustave Moreau",
  description: "Studio-apartment of the Symbolist painter preserved as it was. Spiraling staircases and profusion of mysterious works.",
  price: 7,
  reservation_url: "https://musee-moreau.fr",
  activity_type: "museum",
  address: "14 Rue de La Rochefoucauld, 75009 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Wed-Mon: 10:00 AM-6:00 PM",
  duration: 75,
  tagline: "Dive into the Symbolist universe",
  latitude: 48.8791,
  longitude: 2.3353
)

ActivityItem.create!(
  name: "Musée de la Vie Romantique",
  description: "Intimate villa devoted to Romanticism with secret garden. George Sand memorabilia, bucolic tea salon.",
  price: 0,
  reservation_url: "https://www.museevieromantique.paris.fr",
  activity_type: "museum",
  address: "16 Rue Chaptal, 75009 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sun: 10:00 AM-6:00 PM",
  duration: 75,
  tagline: "A Romantic oasis away from the hustle",
  latitude: 48.8807,
  longitude: 2.3338
)

ActivityItem.create!(
  name: "59 Rivoli",
  description: "Legalized artist squat with 30 studios across 6 floors open to the public. Live creation, affordable art shop.",
  price: 0,
  reservation_url: "https://www.59rivoli.org",
  activity_type: "art",
  address: "59 Rue de Rivoli, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Wed-Sun: 1:00 PM-8:00 PM",
  duration: 60,
  tagline: "Underground art in the heart of Paris",
  latitude: 48.8589,
  longitude: 2.3468
)

ActivityItem.create!(
  name: "Institut du Monde Arabe",
  description: "Contemporary architecture with mechanical carved screens. Arabic art collections, panoramic terrace and Lebanese restaurant.",
  price: 10,
  reservation_url: "https://www.imarabe.org",
  activity_type: "museum",
  address: "1 Rue des Fossés Saint-Bernard, 75005 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Fri: 10:00 AM-6:00 PM, Sat-Sun: 10:00 AM-7:00 PM",
  duration: 120,
  tagline: "East meets West",
  latitude: 48.8514,
  longitude: 2.3543
)

ActivityItem.create!(
  name: "Maison de Victor Hugo",
  description: "Victor Hugo's apartment on Place des Vosges. Manuscripts, drawings and mementos of the writer. Free admission.",
  price: 0,
  reservation_url: "https://www.maisonsvictorhugo.paris.fr",
  activity_type: "museum",
  address: "6 Place des Vosges, 75004 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sun: 10:00 AM-6:00 PM",
  duration: 75,
  tagline: "In the intimate world of a literary giant",
  latitude: 48.8553,
  longitude: 2.3660
)

# ========================================
# 🏛️ MONUMENTS HISTORIQUES (20 items)
# ========================================

puts "Creating historical monuments..."

ActivityItem.create!(
  name: "Sainte-Chapelle",
  description: "13th-century Gothic jewel with 15 monumental stained-glass windows. Magical light and vertiginous architecture.",
  price: 11,
  reservation_url: "https://www.sainte-chapelle.fr",
  activity_type: "monument",
  address: "8 Boulevard du Palais, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 9:00 AM-5:00 PM (until 7:00 PM in summer)",
  duration: 45,
  tagline: "The cathedral of glass and light",
  latitude: 48.8554,
  longitude: 2.3450
)

ActivityItem.create!(
  name: "Panthéon",
  description: "Republican temple housing the tombs of Voltaire, Rousseau, Hugo, Curie. Foucault's pendulum and monumental crypt.",
  price: 11,
  reservation_url: "https://www.paris-pantheon.fr",
  activity_type: "monument",
  address: "Place du Panthéon, 75005 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 10:00 AM-6:30 PM",
  duration: 90,
  tagline: "Where the Republic's great figures rest",
  latitude: 48.8462,
  longitude: 2.3464
)

ActivityItem.create!(
  name: "Arc de Triomphe",
  description: "Napoleonic monument at the top of Champs-Élysées. 360° panoramic view of Paris from the roof.",
  price: 13,
  reservation_url: "https://www.paris-arc-de-triomphe.fr",
  activity_type: "monument",
  address: "Place Charles de Gaulle, 75008 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 10:00 AM-10:30 PM",
  duration: 75,
  tagline: "The star shining over Paris",
  latitude: 48.8738,
  longitude: 2.2950
)

ActivityItem.create!(
  name: "Conciergerie",
  description: "Medieval palace transformed into a revolutionary prison. Marie-Antoinette's cell and impressive Gothic rooms.",
  price: 11,
  reservation_url: "https://www.conciergerie.fr",
  activity_type: "monument",
  address: "2 Boulevard du Palais, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 9:30 AM-6:00 PM",
  duration: 75,
  tagline: "From kings to the Revolution",
  latitude: 48.8560,
  longitude: 2.3456
)

ActivityItem.create!(
  name: "Tour Montparnasse",
  description: "Iconic 1970s skyscraper with panoramic observatory on the 56th floor. Stunning view of the Eiffel Tower.",
  price: 18,
  reservation_url: "https://www.tourmontparnasse56.com",
  activity_type: "viewpoint",
  address: "33 Avenue du Maine, 75015 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 9:30 AM-11:30 PM",
  duration: 60,
  tagline: "Paris from above without waiting in line",
  latitude: 48.8421,
  longitude: 2.3219
)

ActivityItem.create!(
  name: "Basilique du Sacré-Cœur",
  description: "Romano-Byzantine basilica crowning Montmartre. Golden mosaics, crypt and spectacular free view from the esplanade.",
  price: 0,
  reservation_url: "https://www.sacre-coeur-montmartre.com",
  activity_type: "monument",
  address: "35 Rue du Chevalier de la Barre, 75018 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 6:00 AM-10:30 PM (dome 9:00 AM-7:00 PM)",
  duration: 75,
  tagline: "Montmartre's white lighthouse",
  latitude: 48.8867,
  longitude: 2.3431
)

ActivityItem.create!(
  name: "Opéra Garnier",
  description: "Baroque masterpiece of Napoleon III with grand staircase, Chagall ceiling and legendary phantom. Fascinating guided tours.",
  price: 14,
  reservation_url: "https://www.operadeparis.fr",
  activity_type: "monument",
  address: "Place de l'Opéra, 75009 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 10:00 AM-4:30 PM (except during performances)",
  duration: 90,
  tagline: "The Palace of the Opera Phantom",
  latitude: 48.8720,
  longitude: 2.3316
)

ActivityItem.create!(
  name: "Les Invalides",
  description: "Military complex housing Napoleon's tomb under the golden dome. Army Museum and French-style gardens.",
  price: 14,
  reservation_url: "https://www.musee-armee.fr",
  activity_type: "monument",
  address: "129 Rue de Grenelle, 75007 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 10:00 AM-6:00 PM",
  duration: 120,
  tagline: "Napoleon rests under gold",
  latitude: 48.8550,
  longitude: 2.3125
)

ActivityItem.create!(
  name: "Catacombes de Paris",
  description: "Underground ossuary containing the remains of 6 million Parisians. Macabre maze 20 meters below ground, reservation required.",
  price: 15,
  reservation_url: "https://www.catacombes.paris.fr",
  activity_type: "monument",
  address: "1 Avenue du Colonel Henri Rol-Tanguy, 75014 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sun: 9:45 AM-8:30 PM",
  duration: 75,
  tagline: "The empire of death under Paris",
  latitude: 48.8338,
  longitude: 2.3325
)

ActivityItem.create!(
  name: "Notre-Dame de Paris",
  description: "Gothic cathedral undergoing restoration after the 2019 fire. Esplanade accessible, reopening expected end of 2024.",
  price: 0,
  reservation_url: "https://www.notredamedeparis.fr",
  activity_type: "monument",
  address: "6 Parvis Notre-Dame, 75004 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Esplanade accessible 24/7",
  duration: 30,
  tagline: "The phoenix rising from the ashes",
  latitude: 48.8530,
  longitude: 2.3499
)

ActivityItem.create!(
  name: "Château de Vincennes",
  description: "Medieval fortress at Paris's gates with 14th-century keep. Less touristy than Versailles, equally impressive.",
  price: 10,
  reservation_url: "https://www.chateau-vincennes.fr",
  activity_type: "monument",
  address: "Avenue de Paris, 94300 Vincennes",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 10:00 AM-5:00 PM (until 6:00 PM in summer)",
  duration: 105,
  tagline: "The little-known medieval Versailles",
  latitude: 48.8424,
  longitude: 2.4353
)

ActivityItem.create!(
  name: "Tour Eiffel",
  description: "Iconic Iron Lady of Paris. 330 meters tall, 3 accessible floors, twinkling illuminations every hour at night.",
  price: 28,
  reservation_url: "https://www.toureiffel.paris",
  activity_type: "monument",
  address: "Champ de Mars, 5 Avenue Anatole France, 75007 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 9:30 AM-11:45 PM",
  duration: 120,
  tagline: "The icon that sparkles for you",
  latitude: 48.8584,
  longitude: 2.2945
)

ActivityItem.create!(
  name: "Arènes de Lutèce",
  description: "1st-century Roman amphitheater hidden in the 5th arrondissement. Free, peaceful, ideal for picnicking.",
  price: 0,
  reservation_url: "",
  activity_type: "monument",
  address: "49 Rue Monge, 75005 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 8:00 AM-8:00 PM (seasonal)",
  duration: 45,
  tagline: "Paris's forgotten Roman bleachers",
  latitude: 48.8453,
  longitude: 2.3528
)

ActivityItem.create!(
  name: "Palais Royal",
  description: "Secret garden with Buren columns, period shopping arcades and Grand Véfour terrace. Haven of peace in the heart of Paris.",
  price: 0,
  reservation_url: "",
  activity_type: "monument",
  address: "8 Rue de Montpensier, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 7:00 AM-10:30 PM",
  duration: 45,
  tagline: "The striped garden at the heart of power",
  latitude: 48.8638,
  longitude: 2.3372
)

ActivityItem.create!(
  name: "Église Saint-Sulpice",
  description: "Monumental Baroque church with Delacroix frescoes and Da Vinci Code gnomon. Impressive architecture, free admission.",
  price: 0,
  reservation_url: "",
  activity_type: "monument",
  address: "2 Rue Palatine, 75006 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 7:30 AM-7:30 PM",
  duration: 45,
  tagline: "The Da Vinci Code church",
  latitude: 48.8511,
  longitude: 2.3347
)

ActivityItem.create!(
  name: "Église Saint-Eustache",
  description: "Unique blend of Gothic and Renaissance at Les Halles. Monumental organ, regular concerts, spectacular architecture.",
  price: 0,
  reservation_url: "https://www.saint-eustache.org",
  activity_type: "monument",
  address: "2 Impasse Saint-Eustache, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Fri: 9:30 AM-7:00 PM, Sat-Sun: 9:00 AM-7:00 PM",
  duration: 45,
  tagline: "The hidden cathedral of Les Halles",
  latitude: 48.8631,
  longitude: 2.3456
)

ActivityItem.create!(
  name: "Pont Alexandre III",
  description: "Paris's most elegant bridge with Art Nouveau golden streetlamps. Perfect for photos with Invalides view.",
  price: 0,
  reservation_url: "",
  activity_type: "monument",
  address: "Pont Alexandre III, 75008 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "24/7",
  duration: 20,
  tagline: "The postcard bridge of Paris",
  latitude: 48.8637,
  longitude: 2.3136
)

ActivityItem.create!(
  name: "Crypte Archéologique",
  description: "Archaeological site beneath Notre-Dame's esplanade revealing 2000 years of Parisian history. Roman and medieval remains.",
  price: 9,
  reservation_url: "https://www.crypte.paris.fr",
  activity_type: "monument",
  address: "7 Parvis Notre-Dame, 75004 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sun: 10:00 AM-6:00 PM",
  duration: 60,
  tagline: "Paris layer by layer beneath your feet",
  latitude: 48.8534,
  longitude: 2.3488
)

ActivityItem.create!(
  name: "Pavillon de l'Arsenal",
  description: "Architecture and urban planning center presenting Paris's evolution. Interactive giant model, free exhibitions.",
  price: 0,
  reservation_url: "https://www.pavillon-arsenal.com",
  activity_type: "monument",
  address: "21 Boulevard Morland, 75004 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Sun: 11:00 AM-7:00 PM",
  duration: 75,
  tagline: "Understand how Paris was built",
  latitude: 48.8510,
  longitude: 2.3618
)

ActivityItem.create!(
  name: "La Coulée Verte",
  description: "4.5km planted promenade on former railway track. From Bastille to Bois de Vincennes, street art and suspended gardens.",
  price: 0,
  reservation_url: "",
  activity_type: "outdoor",
  address: "1 Coulée Verte René-Dumont, 75012 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 8:00 AM-8:30 PM (seasonal)",
  duration: 90,
  tagline: "The High Line before the High Line",
  latitude: 48.8490,
  longitude: 2.3720
)

# ========================================
# 🎭 ÉVÉNEMENTS CULTURELS (15 items)
# ========================================

puts "Creating cultural events..."

ActivityItem.create!(
  name: "Concert à la Philharmonie",
  description: "Concert hall with futuristic design and exceptional acoustics. Paris Orchestra, classical and contemporary concerts.",
  price: 35,
  reservation_url: "https://philharmoniedeparis.fr",
  activity_type: "concert",
  address: "221 Avenue Jean Jaurès, 75019 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Hours vary by program",
  duration: 150,
  tagline: "The spacecraft of classical music",
  latitude: 48.8891,
  longitude: 2.3936
)

ActivityItem.create!(
  name: "Soirée au Crazy Horse",
  description: "Mythical cabaret with artistic nude show and avant-garde light effects. Champagne and Parisian glamour.",
  price: 90,
  reservation_url: "https://lecrazyhorseparis.com",
  activity_type: "show",
  address: "12 Avenue George V, 75008 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Shows at 7:00 PM and 9:30 PM",
  duration: 90,
  tagline: "The art of nudity reinvented",
  latitude: 48.8674,
  longitude: 2.3016
)

ActivityItem.create!(
  name: "Cinéma Le Grand Rex",
  description: "Europe's largest cinema with monumental Art Deco decor. Premieres and backstage visits possible.",
  price: 12,
  reservation_url: "https://www.legrandrex.com",
  activity_type: "cinema",
  address: "1 Boulevard Poissonnière, 75002 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Screenings 10:00 AM to midnight",
  duration: 150,
  tagline: "The temple of Paris cinema",
  latitude: 48.8708,
  longitude: 2.3474
)

ActivityItem.create!(
  name: "Moulin Rouge",
  description: "Legendary cabaret with Féerie show and French can-can. Rhinestones, feathers and champagne in Belle Époque atmosphere.",
  price: 120,
  reservation_url: "https://www.moulinrouge.fr",
  activity_type: "show",
  address: "82 Boulevard de Clichy, 75018 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Dinner-show 7:00 PM, Show only 9:00 PM and 11:00 PM",
  duration: 120,
  tagline: "The French can-can that makes the world dream",
  latitude: 48.8841,
  longitude: 2.3322
)

ActivityItem.create!(
  name: "Jazz au Duc des Lombards",
  description: "Intimate Saint-Germain jazz club. Sophisticated programming, international artists, hushed atmosphere and vaulted cellar.",
  price: 25,
  reservation_url: "https://www.ducdeslombards.com",
  activity_type: "concert",
  address: "42 Rue des Lombards, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Concerts at 8:00 PM and 10:00 PM",
  duration: 120,
  tagline: "The temple of Parisian jazz",
  latitude: 48.8593,
  longitude: 2.3492
)

ActivityItem.create!(
  name: "Comédie-Française",
  description: "National theater with permanent company performing classical repertoire. Molière, Racine in the historic Richelieu room.",
  price: 30,
  reservation_url: "https://www.comedie-francaise.fr",
  activity_type: "theater",
  address: "Place Colette, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Evening performances and Sunday matinees",
  duration: 180,
  tagline: "Molière's house since 1680",
  latitude: 48.8635,
  longitude: 2.3359
)

ActivityItem.create!(
  name: "New Morning",
  description: "Mythical jazz and world music concert hall. Perfect acoustics, eclectic programming, friendly bar.",
  price: 28,
  reservation_url: "https://www.newmorning.com",
  activity_type: "concert",
  address: "7-9 Rue des Petites Écuries, 75010 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Concerts at 8:30 PM",
  duration: 135,
  tagline: "Where jazz lives every night",
  latitude: 48.8729,
  longitude: 2.3504
)

ActivityItem.create!(
  name: "Cinéma La Pagode",
  description: "Art house cinema in a 19th-century Japanese pagoda. Zen garden, demanding programming, unique architecture.",
  price: 11,
  reservation_url: "https://www.cinemaspagode.fr",
  activity_type: "cinema",
  address: "57bis Rue de Babylone, 75007 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Screenings 2:00 PM to 10:00 PM",
  duration: 135,
  tagline: "Watch a film in a pagoda",
  latitude: 48.8515,
  longitude: 2.3166
)

ActivityItem.create!(
  name: "Théâtre de l'Odéon",
  description: "National theater with bold contemporary programming. Neoclassical architecture, contemporary authors and innovative directors.",
  price: 28,
  reservation_url: "https://www.theatre-odeon.eu",
  activity_type: "theater",
  address: "Place de l'Odéon, 75006 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Evening and weekend performances",
  duration: 150,
  tagline: "The theater that breaks the rules",
  latitude: 48.8493,
  longitude: 2.3388
)

ActivityItem.create!(
  name: "L'Olympia",
  description: "Mythical concert hall that hosted all the greats. Édith Piaf, Brel, now pop-rock and variety concerts.",
  price: 45,
  reservation_url: "https://www.olympiahall.com",
  activity_type: "concert",
  address: "28 Boulevard des Capucines, 75009 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Hours vary by program",
  duration: 150,
  tagline: "The red hall where legends were born",
  latitude: 48.8702,
  longitude: 2.3282
)

ActivityItem.create!(
  name: "Point Éphémère",
  description: "Alternative cultural venue on Canal Saint-Martin. Concerts, exhibitions, clubbing and terrace in summer.",
  price: 15,
  reservation_url: "https://www.pointephemere.org",
  activity_type: "concert",
  address: "200 Quai de Valmy, 75010 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Wed-Sun: 12:00 PM-2:00 AM",
  duration: 180,
  tagline: "Underground culture by the water",
  latitude: 48.8815,
  longitude: 2.3665
)

ActivityItem.create!(
  name: "Opéra Bastille",
  description: "Modern opera with exceptional acoustics. Ambitious opera and ballet productions, perfect visibility from all seats.",
  price: 50,
  reservation_url: "https://www.operadeparis.fr",
  activity_type: "show",
  address: "Place de la Bastille, 75012 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Evening performances",
  duration: 210,
  tagline: "Opera for the people",
  latitude: 48.8520,
  longitude: 2.3698
)

ActivityItem.create!(
  name: "Café de la Danse",
  description: "Intimate concert hall in the 11th. Indie rock, electro, French chanson. Close proximity with artists.",
  price: 22,
  reservation_url: "https://cafedeladanse.com",
  activity_type: "concert",
  address: "5 Passage Louis-Philippe, 75011 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Concerts at 8:00 PM",
  duration: 120,
  tagline: "Two meters from the stage",
  latitude: 48.8531,
  longitude: 2.3730
)

ActivityItem.create!(
  name: "Shakespeare and Company Readings",
  description: "Author readings and meetings in the iconic English-language bookstore. Free, literary bohemian atmosphere.",
  price: 0,
  reservation_url: "https://shakespeareandcompany.com",
  activity_type: "cultural",
  address: "37 Rue de la Bûcherie, 75005 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 10:00 AM-10:00 PM, variable events",
  duration: 90,
  tagline: "Where words come to life",
  latitude: 48.8526,
  longitude: 2.3471
)

ActivityItem.create!(
  name: "Parc de la Villette - Cinéma en plein air",
  description: "Open-air film screenings in summer on giant screen. Picnic atmosphere, classics and new releases, free or low price.",
  price: 5,
  reservation_url: "https://lavillette.com",
  activity_type: "cinema",
  address: "211 Avenue Jean Jaurès, 75019 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Jul-Aug: dusk",
  duration: 150,
  tagline: "Cinema under the Paris stars",
  latitude: 48.8937,
  longitude: 2.3909
)

# ========================================
# ⚽ ACTIVITÉS SPORTIVES & LOISIRS (10 items)
# ========================================

puts "Creating sports and leisure activities..."

ActivityItem.create!(
  name: "Croisière sur la Seine",
  description: "Narrated boat tour passing all monuments. Eiffel Tower, Notre-Dame, Louvre illuminated in the evening.",
  price: 16,
  reservation_url: "https://www.bateaux-parisiens.com",
  activity_type: "cruise",
  address: "Port de la Bourdonnais, 75007 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Departures every 30 min from 10:00 AM to 10:00 PM",
  duration: 70,
  tagline: "Paris seen from its waters",
  latitude: 48.8600,
  longitude: 2.2932
)

ActivityItem.create!(
  name: "Ballon de Paris",
  description: "Tethered hot air balloon ascending to 150 meters. 360° panoramic view of Paris, gentle sensations, accessible for disabled.",
  price: 16,
  reservation_url: "https://ballondeparis.com",
  activity_type: "outdoor",
  address: "Parc André Citroën, 75015 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Wed-Sun: 9:00 AM-7:00 PM (weather permitting)",
  duration: 30,
  tagline: "Soar above Paris",
  latitude: 48.8414,
  longitude: 2.2746
)

ActivityItem.create!(
  name: "Vélo le long du Canal Saint-Martin",
  description: "Bike ride from Bastille to La Villette along the canal. Picturesque locks, street art, trendy bars and cafés.",
  price: 15,
  reservation_url: "https://velib-metropole.fr",
  activity_type: "outdoor",
  address: "Departure Point de la Bastille, 75011 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "24/7 (Vélib rental)",
  duration: 120,
  tagline: "Paris at the pace of barges",
  latitude: 48.8530,
  longitude: 2.3690
)

ActivityItem.create!(
  name: "Piscine Joséphine Baker",
  description: "Floating pool on the Seine with retractable roof in summer. Pools, solarium, view of Bercy. Unique experience.",
  price: 7,
  reservation_url: "https://www.paris.fr/equipements/piscine-josephine-baker-1752",
  activity_type: "sport",
  address: "Quai François Mauriac, 75013 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Tue-Fri: 1:00 PM-8:00 PM, Sat-Sun: 10:00 AM-8:00 PM",
  duration: 120,
  tagline: "Swim on the Seine",
  latitude: 48.8341,
  longitude: 2.3768
)

ActivityItem.create!(
  name: "Jardin du Luxembourg",
  description: "French-style park with iconic green chairs. Model sailing boat pond, tennis, jogging, outdoor chess.",
  price: 0,
  reservation_url: "",
  activity_type: "outdoor",
  address: "Rue de Vaugirard, 75006 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 7:30 AM-9:30 PM (seasonal)",
  duration: 90,
  tagline: "The garden where strolling becomes an art",
  latitude: 48.8462,
  longitude: 2.3372
)

ActivityItem.create!(
  name: "Parc des Buttes-Chaumont",
  description: "Rolling park with lake, waterfall, Greek temple at the summit. View of Montmartre, grottos, suspension bridges. Perfect for picnicking.",
  price: 0,
  reservation_url: "",
  activity_type: "outdoor",
  address: "1 Rue Botzaris, 75019 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Sun: 7:00 AM-10:00 PM (seasonal)",
  duration: 120,
  tagline: "The romantic park with mountain-like charm",
  latitude: 48.8809,
  longitude: 2.3820
)

ActivityItem.create!(
  name: "Roller à Rollers & Coquillages",
  description: "Roller tour all levels every Friday evening. 20-30km through Paris at night, festive and safe atmosphere.",
  price: 0,
  reservation_url: "https://www.pari-roller.com",
  activity_type: "sport",
  address: "Departure Place Raoul Dautry (Montparnasse), 75015 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Fri: departure 10:00 PM",
  duration: 180,
  tagline: "Paris on roller blades by night",
  latitude: 48.8414,
  longitude: 2.3209
)

ActivityItem.create!(
  name: "MurMur Escalade Pantin",
  description: "Modern bouldering climbing hall. 1500 sq meters of walls, regularly updated problems, cosy café. Beginners and experienced welcome.",
  price: 16,
  reservation_url: "https://murmur.fr",
  activity_type: "sport",
  address: "55 Rue Cartier Bresson, 93500 Pantin",
  city: "Paris",
  country: "France",
  opening_hours: "Mon-Fri: 10:00 AM-11:00 PM, Sat-Sun: 10:00 AM-8:00 PM",
  duration: 150,
  tagline: "Climb in the former France Telecom building",
  latitude: 48.8962,
  longitude: 2.4014
)

ActivityItem.create!(
  name: "Bois de Vincennes",
  description: "Paris's largest green space with 4 lakes, zoo, castle, open-air theater. Biking, boating, jogging, picnicking.",
  price: 0,
  reservation_url: "",
  activity_type: "outdoor",
  address: "Route de la Pyramide, 75012 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "24/7",
  duration: 180,
  tagline: "The urban forest of eastern Paris",
  latitude: 48.8303,
  longitude: 2.4337
)

ActivityItem.create!(
  name: "Berges de Seine",
  description: "Pedestrian promenade along the left bank. Free summer activities, food trucks, open-air taverns, pedal boats. Festive atmosphere.",
  price: 0,
  reservation_url: "",
  activity_type: "outdoor",
  address: "Quai Anatole France to Quai de la Gare, 75007 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "24/7",
  duration: 120,
  tagline: "Paris beach all year round",
  latitude: 48.8576,
  longitude: 2.3200
)


puts "✅ Activity items created"

# ==============================================
# TRIP 1: trip created no invitation sent
# ==============================================
puts "\n🌍 Creating Trip 1: trip created no invitation sent..."

trip1 = Trip.create!(
  name: "trip created no invitation sent",
  destination: "Paris, France",
  start_date: "2026-05-10",
  end_date: "2026-05-17",
  trip_type: "cultural"
)

# Monica is the creator - has NOT filled preferences yet
UserTripStatus.create!(
  user: monica,
  trip: trip1,
  role: "creator",
  trip_status: "pending_preferences",
  is_invited: false,
  invitation_accepted: true,
  form_filled: false,
  recommendation_reviewed: false
)

puts "✅ Trip 1 created: #{trip1.name}"

# ==============================================
# TRIP 2: trip created and activity to review
# ==============================================
puts "\n📋 Creating Trip 2: trip created and activity to review..."

trip2 = Trip.create!(
  name: "trip created and activity to review",
  destination: "Paris, France",
  start_date: "2026-07-01",
  end_date: "2026-07-08",
  trip_type: "cultural"
)

# Monica is the creator (form filled)
uts_monica_trip2 = UserTripStatus.create!(
  user: monica,
  trip: trip2,
  role: "creator",
  trip_status: "reviewing_suggestions",
  is_invited: false,
  invitation_accepted: true,
  form_filled: true,
  recommendation_reviewed: false
)

PreferencesForm.create!(
  user_trip_status: uts_monica_trip2,
  travel_pace: "moderate",
  budget: 2500,
  interests: { "culture" => 4, "food" => 5, "shopping" => 3 },
  activity_types: "cultural, food"
)

# Chandler participant (form filled)
uts_chandler_trip2 = UserTripStatus.create!(
  user: chandler,
  trip: trip2,
  role: "participant",
  trip_status: "reviewing_suggestions",
  is_invited: true,
  invitation_accepted: true,
  form_filled: true,
  recommendation_reviewed: false
)

PreferencesForm.create!(
  user_trip_status: uts_chandler_trip2,
  travel_pace: "relaxed",
  budget: 2000,
  interests: { "culture" => 3, "food" => 4, "nightlife" => 4 },
  activity_types: "cultural, food, nightlife"
)

# Rachel participant (form filled)
uts_rachel_trip2 = UserTripStatus.create!(
  user: rachel,
  trip: trip2,
  role: "participant",
  trip_status: "reviewing_suggestions",
  is_invited: true,
  invitation_accepted: true,
  form_filled: true,
  recommendation_reviewed: false
)

PreferencesForm.create!(
  user_trip_status: uts_rachel_trip2,
  travel_pace: "moderate",
  budget: 3000,
  interests: { "culture" => 5, "shopping" => 5, "food" => 4 },
  activity_types: "cultural, shopping, food"
)

# Create recommendations for Trip 2
recommendation_trip2 = Recommendation.create!(
  trip: trip2,
  accepted: nil,
  system_prompt: "Generate cultural and gastronomy activities for Paris"
)

# Add recommendation items
[
  "Musée d'Orsay",
  "Le Comptoir du Relais",
  "Sainte-Chapelle",
  "Café de Flore",
  "Centre Pompidou",
  "Breizh Café",
  "Musée Rodin",
  "L'As du Fallafel"
].each do |activity_name|
  activity = ActivityItem.find_by(name: activity_name)
  RecommendationItem.create!(
    recommendation: recommendation_trip2,
    activity_item: activity
  ) if activity
end

puts "✅ Trip 2 created with #{trip2.user_trip_statuses.count} participants and #{recommendation_trip2.recommendation_items.count} recommendations"

# ==============================================
# TRIP 3: Finalized with 7-day itinerary
# ==============================================
puts "\n✈️ Creating Trip 3: Finalized with itinerary..."

trip3 = Trip.create!(
  name: "Paris Adventure - Complete",
  destination: "Paris, France",
  start_date: "2026-09-15",
  end_date: "2026-09-21",
  trip_type: "cultural"
)

# Monica is the creator (form filled)
uts_monica_trip3 = UserTripStatus.create!(
  user: monica,
  trip: trip3,
  role: "creator",
  trip_status: "itinerary_ready",
  is_invited: false,
  invitation_accepted: true,
  form_filled: true,
  recommendation_reviewed: true
)

PreferencesForm.create!(
  user_trip_status: uts_monica_trip3,
  travel_pace: "intense",
  budget: 3000,
  interests: { "culture" => 5, "food" => 5, "shopping" => 2 },
  activity_types: "cultural, food"
)

# Chandler participant (form filled)
uts_chandler_trip3 = UserTripStatus.create!(
  user: chandler,
  trip: trip3,
  role: "participant",
  trip_status: "itinerary_ready",
  is_invited: true,
  invitation_accepted: true,
  form_filled: true,
  recommendation_reviewed: true
)

PreferencesForm.create!(
  user_trip_status: uts_chandler_trip3,
  travel_pace: "moderate",
  budget: 2500,
  interests: { "culture" => 3, "food" => 4, "nightlife" => 5 },
  activity_types: "cultural, food, nightlife"
)

# Rachel participant (form filled)
uts_rachel_trip3 = UserTripStatus.create!(
  user: rachel,
  trip: trip3,
  role: "participant",
  trip_status: "itinerary_ready",
  is_invited: true,
  invitation_accepted: true,
  form_filled: true,
  recommendation_reviewed: true
)

PreferencesForm.create!(
  user_trip_status: uts_rachel_trip3,
  travel_pace: "moderate",
  budget: 3500,
  interests: { "culture" => 5, "shopping" => 5, "food" => 5 },
  activity_types: "cultural, shopping, food"
)

# Create accepted recommendations for Trip 3
recommendation_trip3 = Recommendation.create!(
  trip: trip3,
  accepted: true,
  system_prompt: "Generate cultural, gastronomy and shopping activities for Paris"
)

# Add recommendation items for Trip 3
trip3_activities = [
  "Musée d'Orsay", "Le Comptoir du Relais", "Sainte-Chapelle", "Café de Flore",
  "Centre Pompidou", "Breizh Café", "Musée Rodin", "L'As du Fallafel",
  "Angelina", "Musée Picasso", "Tour Eiffel", "Croisière sur la Seine",
  "Pink Mamma", "Opéra Garnier"
]

trip3_activities.each do |activity_name|
  activity = ActivityItem.find_by(name: activity_name)
  RecommendationItem.create!(
    recommendation: recommendation_trip3,
    activity_item: activity
  ) if activity
end

# Create 7-day itinerary for Trip 3
puts "📅 Creating 7-day itinerary for Trip 3..."

itinerary_trip3 = Itinerary.create!(
  trip: trip3,
  system_prompt: "Generate a 7-day cultural and gastronomy itinerary for Paris"
)

# Day 1 - 2026-09-15
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Café de Flore"), date: "2026-09-15", time: "09:00", position: "1")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Musée d'Orsay"), date: "2026-09-15", time: "10:30", position: "2")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "L'As du Fallafel"), date: "2026-09-15", time: "13:00", position: "3")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Sainte-Chapelle"), date: "2026-09-15", time: "15:00", position: "4")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Le Comptoir du Relais"), date: "2026-09-15", time: "19:30", position: "5")

# Day 2 - 2026-09-16
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Angelina"), date: "2026-09-16", time: "09:00", position: "1")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Musée Rodin"), date: "2026-09-16", time: "11:00", position: "2")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Breizh Café"), date: "2026-09-16", time: "13:00", position: "3")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Tour Eiffel"), date: "2026-09-16", time: "15:30", position: "4")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Pink Mamma"), date: "2026-09-16", time: "20:00", position: "5")

# Day 3 - 2026-09-17
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Café Kitsuné"), date: "2026-09-17", time: "09:00", position: "1")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Centre Pompidou"), date: "2026-09-17", time: "11:00", position: "2")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Nanashi"), date: "2026-09-17", time: "13:00", position: "3")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Musée Picasso"), date: "2026-09-17", time: "15:00", position: "4")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Frenchie"), date: "2026-09-17", time: "19:30", position: "5")

# Day 4 - 2026-09-18
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Holybelly"), date: "2026-09-18", time: "09:30", position: "1")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Opéra Garnier"), date: "2026-09-18", time: "11:30", position: "2")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Ellsworth"), date: "2026-09-18", time: "13:30", position: "3")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Palais Royal"), date: "2026-09-18", time: "15:30", position: "4")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Septime"), date: "2026-09-18", time: "20:00", position: "5")

# Day 5 - 2026-09-19
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Claus"), date: "2026-09-19", time: "09:00", position: "1")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Musée de l'Orangerie"), date: "2026-09-19", time: "10:30", position: "2")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Chez Janou"), date: "2026-09-19", time: "13:00", position: "3")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Atelier des Lumières"), date: "2026-09-19", time: "16:00", position: "4")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Bistrot Paul Bert"), date: "2026-09-19", time: "20:00", position: "5")

# Day 6 - 2026-09-20
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "KB CaféShop"), date: "2026-09-20", time: "09:00", position: "1")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Panthéon"), date: "2026-09-20", time: "11:00", position: "2")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Miznon"), date: "2026-09-20", time: "13:00", position: "3")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Jardin du Luxembourg"), date: "2026-09-20", time: "15:00", position: "4")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Le Chateaubriand"), date: "2026-09-20", time: "19:30", position: "5")

# Day 7 - 2026-09-21
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Carette"), date: "2026-09-21", time: "10:00", position: "1")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Croisière sur la Seine"), date: "2026-09-21", time: "11:30", position: "2")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Le Relais de l'Entrecôte"), date: "2026-09-21", time: "13:30", position: "3")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Arc de Triomphe"), date: "2026-09-21", time: "16:00", position: "4")
ItineraryItem.create!(itinerary: itinerary_trip3, activity_item: ActivityItem.find_by(name: "Le Train Bleu"), date: "2026-09-21", time: "19:30", position: "5")

puts "✅ Trip 3 created with #{trip3.user_trip_statuses.count} participants, #{recommendation_trip3.recommendation_items.count} recommendations, and #{itinerary_trip3.itinerary_items.count} itinerary items over 7 days"

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
puts "  📅 Itineraries: #{Itinerary.count}"
puts "  🗓️  Itinerary Items: #{ItineraryItem.count}"
puts "\n✨ Trips created:"
puts "  • Trip 1: #{trip1.name} - Monica seule, pas de préférences"
puts "  • Trip 2: #{trip2.name} - Monica + Chandler + Rachel, en review"
puts "  • Trip 3: #{trip3.name} - Monica + Chandler + Rachel, itinéraire 7 jours"
puts "="*50

puts "\n🔑 Identifiants de connexion:"
puts "-"*50
puts "Monica Geller (créatrice des trips):"
puts "  Email: monica@yugo.com"
puts "  Password: password123"
puts ""
puts "Chandler Bing (participant):"
puts "  Email: chandler@yugo.com"
puts "  Password: password123"
puts ""
puts "Rachel Green (participante):"
puts "  Email: rachel@yugo.com"
puts "  Password: password123"
puts "="*50

# Restore original job adapter
ActiveJob::Base.queue_adapter = original_adapter

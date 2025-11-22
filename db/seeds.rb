# Clean database
puts "🧹 Cleaning database..."
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
  start_date: "2026-03-15",
  end_date: "2026-03-17",
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
  start_date: "2026-09-26",
  end_date: "2026-09-28",
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
  start_date: "2026-07-10",
  end_date: "2026-07-24",
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
  travel_pace: "moderate",
  budget: 3000,
  interests: "temples, sushi, gardens",
  activity_types: "cultural, food, nature"
)

# Create some activity items for recommendations
puts "\n🎯 Creating Paris activity items..."

# ========================================
# 🍽️ RESTAURANTS & CAFÉS (30 items)
# ========================================

puts "Creating restaurants and cafés..."

ActivityItem.create!(
  name: "Le Comptoir du Relais",
  description: "Bistrot parisien emblématique servant une cuisine française traditionnelle dans une ambiance animée. Réservation indispensable.",
  price: 45,
  reservation_url: "https://hotel-paris-relais-saint-germain.com",
  activity_type: "restaurant",
  address: "9 Carrefour de l'Odéon, 75006 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Sam: 12h-14h30, 19h-23h",
  duration: 120,
  tagline: "Le bistrot préféré des Parisiens initiés"
)

ActivityItem.create!(
  name: "Breizh Café",
  description: "Les meilleures crêpes bretonnes de Paris, avec des produits bio et du cidre artisanal. Ambiance chaleureuse et authentique.",
  price: 18,
  reservation_url: "https://breizhcafe.com",
  activity_type: "restaurant",
  address: "109 Rue Vieille du Temple, 75003 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mer-Dim: 11h30-23h",
  duration: 90,
  tagline: "La Bretagne au cœur du Marais"
)

ActivityItem.create!(
  name: "L'As du Fallafel",
  description: "Institution du quartier juif servant les meilleurs falafels de Paris depuis 1979. File d'attente garantie mais ça vaut le coup !",
  price: 8,
  reservation_url: "",
  activity_type: "restaurant",
  address: "34 Rue des Rosiers, 75004 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Dim-Jeu: 11h-23h, Ven: 11h-18h",
  duration: 45,
  tagline: "Le falafel légendaire du Marais"
)

ActivityItem.create!(
  name: "Café de Flore",
  description: "Café historique de Saint-Germain-des-Prés, repaire des intellectuels et artistes depuis 1887. Ambiance Art Déco préservée.",
  price: 12,
  reservation_url: "https://cafedeflore.fr",
  activity_type: "cafe",
  address: "172 Boulevard Saint-Germain, 75006 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 7h-1h30",
  duration: 60,
  tagline: "Là où Sartre écrivait ses manifestes"
)

ActivityItem.create!(
  name: "Septime",
  description: "Restaurant gastronomique moderne avec une cuisine inventive et des produits de saison. Une étoile au Michelin, ambiance décontractée.",
  price: 85,
  reservation_url: "https://septime-charonne.fr",
  activity_type: "restaurant",
  address: "80 Rue de Charonne, 75011 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Ven: 12h-14h, 19h30-22h",
  duration: 150,
  tagline: "La nouvelle garde de la gastronomie parisienne"
)

ActivityItem.create!(
  name: "Angelina",
  description: "Salon de thé Belle Époque célèbre pour son chocolat chaud onctueux et son Mont-Blanc légendaire. Décor somptueux.",
  price: 15,
  reservation_url: "https://angelina-paris.fr",
  activity_type: "cafe",
  address: "226 Rue de Rivoli, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 7h30-19h",
  duration: 75,
  tagline: "Le chocolat chaud qui réchauffe Paris depuis 1903"
)

ActivityItem.create!(
  name: "Chez Janou",
  description: "Bistrot provençal authentique avec sa terrasse ombragée et plus de 90 pastis au comptoir. Ambiance du Sud garantie.",
  price: 28,
  reservation_url: "https://chezjanou.com",
  activity_type: "restaurant",
  address: "2 Rue Roger Verlomme, 75003 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 12h-15h, 19h-23h30",
  duration: 120,
  tagline: "Un coin de Provence dans le Marais"
)

ActivityItem.create!(
  name: "Pink Mamma",
  description: "Trattoria italienne XXL sur 4 étages avec décor végétal spectaculaire. Pâtes fraîches et pizzas au feu de bois.",
  price: 25,
  reservation_url: "https://bigmammagroup.com/fr/trattorias/pink-mamma",
  activity_type: "restaurant",
  address: "20bis Rue de Douai, 75009 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 12h-14h30, 18h30-23h",
  duration: 105,
  tagline: "L'Italie grandeur nature à Pigalle"
)

ActivityItem.create!(
  name: "Le Relais de l'Entrecôte",
  description: "Restaurant culte sans carte : steak-frites sauce secrète, salade de noix en entrée. Simple et délicieux, pas de réservation.",
  price: 30,
  reservation_url: "",
  activity_type: "restaurant",
  address: "15 Rue Marbeuf, 75008 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 12h-14h30, 19h-23h",
  duration: 90,
  tagline: "Une seule option, zéro déception"
)

ActivityItem.create!(
  name: "Café Kitsuné",
  description: "Coffee shop japonais minimaliste servant des cafés de spécialité et pâtisseries fusion. Design épuré, produits d'exception.",
  price: 6,
  reservation_url: "https://cafekitsune.com",
  activity_type: "cafe",
  address: "51 Galerie de Montpensier, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 9h-18h",
  duration: 45,
  tagline: "L'art du café à la japonaise"
)

ActivityItem.create!(
  name: "Bouillon Chartier",
  description: "Bouillon historique de 1896 avec décor classé. Cuisine française traditionnelle à petits prix dans un cadre Belle Époque.",
  price: 18,
  reservation_url: "",
  activity_type: "restaurant",
  address: "7 Rue du Faubourg Montmartre, 75009 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 11h30-22h",
  duration: 90,
  tagline: "Manger comme en 1900 sans se ruiner"
)

ActivityItem.create!(
  name: "Frenchie",
  description: "Bistrot moderne de Gregory Marchand, pionnier de la bistronomie parisienne. Cuisine créative avec produits locaux.",
  price: 60,
  reservation_url: "https://frenchie-restaurant.com",
  activity_type: "restaurant",
  address: "5 Rue du Nil, 75002 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Sam: 19h-22h",
  duration: 135,
  tagline: "Le bistrot qui a révolutionné la scène parisienne"
)

ActivityItem.create!(
  name: "Holybelly",
  description: "Brunch anglo-saxon culte avec pancakes fluffy et café de spécialité. File d'attente dès l'ouverture le weekend.",
  price: 22,
  reservation_url: "",
  activity_type: "cafe",
  address: "19 Rue Lucien Sampaix, 75010 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mer-Ven: 9h-17h, Sam-Dim: 9h-18h",
  duration: 90,
  tagline: "Le brunch qui vaut le réveil du weekend"
)

ActivityItem.create!(
  name: "Le Train Bleu",
  description: "Restaurant mythique de la Gare de Lyon avec décor Second Empire classé monument historique. Cuisine gastronomique française.",
  price: 75,
  reservation_url: "https://le-train-bleu.com",
  activity_type: "restaurant",
  address: "Place Louis-Armand, Gare de Lyon, 75012 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 11h30-15h, 19h-23h",
  duration: 150,
  tagline: "Voyager dans le temps sans quitter Paris"
)

ActivityItem.create!(
  name: "Miznon",
  description: "Street food israélienne créative dans une ambiance électrique. Pitas garnis généreusement, légumes rôtis au four à bois.",
  price: 14,
  reservation_url: "",
  activity_type: "restaurant",
  address: "22 Rue des Ecouffes, 75004 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 12h-23h",
  duration: 60,
  tagline: "Tel Aviv débarque dans le Marais"
)

ActivityItem.create!(
  name: "La Jacobine",
  description: "Salon de thé littéraire cosy avec une sélection exceptionnelle de thés du monde. Parfait pour bouquiner l'après-midi.",
  price: 8,
  reservation_url: "",
  activity_type: "cafe",
  address: "59-61 Rue Saint-André des Arts, 75006 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 11h-19h",
  duration: 90,
  tagline: "Le refuge secret des amoureux de thé et livres"
)

ActivityItem.create!(
  name: "Chez L'Ami Jean",
  description: "Bistrot basque généreux servant des plats copieux et une ambiance conviviale. Le riz au lait est légendaire.",
  price: 50,
  reservation_url: "https://lamijean.fr",
  activity_type: "restaurant",
  address: "27 Rue Malar, 75007 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Sam: 12h-14h, 19h-23h",
  duration: 120,
  tagline: "Partage et générosité à la basquaise"
)

ActivityItem.create!(
  name: "Claus",
  description: "Petit-déjeuner et brunch haut de gamme avec produits artisanaux. Confitures maison et viennoiseries exceptionnelles.",
  price: 20,
  reservation_url: "https://clausparis.com",
  activity_type: "cafe",
  address: "14 Rue Jean-Jacques Rousseau, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 8h30-17h",
  duration: 75,
  tagline: "Le petit-déjeuner version luxe"
)

ActivityItem.create!(
  name: "Le Baratin",
  description: "Bistrot de quartier culte à Belleville. Cuisine du marché inventive, cave exceptionnelle, pas de carte bancaire.",
  price: 35,
  reservation_url: "",
  activity_type: "restaurant",
  address: "3 Rue Jouye-Rouve, 75020 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Sam: 12h-14h30, 19h30-23h",
  duration: 120,
  tagline: "Le bistrot secret des vrais Parisiens"
)

ActivityItem.create!(
  name: "Ellsworth",
  description: "Restaurant américano-parisien avec brunch le weekend et dîner créatif en semaine. Ambiance décontractée et chaleureuse.",
  price: 28,
  reservation_url: "https://ellsworthparis.com",
  activity_type: "restaurant",
  address: "34 Rue de Richelieu, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Sam: 12h-15h, 18h-23h, Dim: 11h-16h",
  duration: 105,
  tagline: "Brooklyn rencontre Paris"
)

ActivityItem.create!(
  name: "Le Consulat",
  description: "Café historique de Montmartre avec terrasse pittoresque. Vue imprenable sur la Place du Tertre, ambiance bohème.",
  price: 10,
  reservation_url: "",
  activity_type: "cafe",
  address: "18 Rue Norvins, 75018 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 8h-1h",
  duration: 60,
  tagline: "Le café carte postale de Montmartre"
)

ActivityItem.create!(
  name: "Bistrot Paul Bert",
  description: "Archétype du bistrot parisien traditionnel. Viandes maturées, tartare au couteau, décor rétro intact depuis des décennies.",
  price: 38,
  reservation_url: "https://bistrotpaulbert.com",
  activity_type: "restaurant",
  address: "18 Rue Paul Bert, 75011 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Sam: 12h-14h, 19h30-23h",
  duration: 120,
  tagline: "Le bistrot dans toute sa splendeur"
)

ActivityItem.create!(
  name: "KB CaféShop",
  description: "Coffee shop australien pionnier du flat white à Paris. Brunch healthy, excellent café et ambiance décontractée.",
  price: 15,
  reservation_url: "https://kbcafeshop.com",
  activity_type: "cafe",
  address: "53 Avenue Trudaine, 75009 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Ven: 8h-17h, Sam-Dim: 9h-18h",
  duration: 75,
  tagline: "L'Australie coffee culture à Pigalle"
)

ActivityItem.create!(
  name: "Le Chateaubriand",
  description: "Restaurant néo-bistrot avant-gardiste d'Iñaki Aizpitarte. Menu surprise quotidien, créativité sans limite.",
  price: 70,
  reservation_url: "",
  activity_type: "restaurant",
  address: "129 Avenue Parmentier, 75011 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Sam: 19h-22h",
  duration: 150,
  tagline: "L'audace culinaire made in Paris"
)

ActivityItem.create!(
  name: "Carette",
  description: "Pâtisserie-salon de thé chic face à la Place des Vosges. Macarons, éclairs et chocolat viennois dans un cadre élégant.",
  price: 12,
  reservation_url: "https://carette-paris.fr",
  activity_type: "cafe",
  address: "25 Place des Vosges, 75003 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 8h-19h",
  duration: 60,
  tagline: "La douceur parisienne sur la plus belle place"
)

ActivityItem.create!(
  name: "Nanashi",
  description: "Bento bar japonais authentique avec gyozas faits maison et bentos équilibrés. Queue à l'heure du déjeuner mais service rapide.",
  price: 14,
  reservation_url: "",
  activity_type: "restaurant",
  address: "31 Rue de Paradis, 75010 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Sam: 12h-15h, 19h-22h30",
  duration: 45,
  tagline: "Le Japon authentique sans fioritures"
)

ActivityItem.create!(
  name: "Le Servan",
  description: "Néo-bistrot des sœurs Levha mêlant cuisine française et influences asiatiques. Accord mets-vins naturels exceptionnel.",
  price: 45,
  reservation_url: "https://leservan.com",
  activity_type: "restaurant",
  address: "32 Rue Saint-Maur, 75011 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Sam: 12h-14h30, 19h-22h30",
  duration: 135,
  tagline: "Fusion franco-asiatique par deux sœurs talentueuses"
)

ActivityItem.create!(
  name: "Les Deux Magots",
  description: "Café littéraire mythique de Saint-Germain fréquenté par Hemingway et Sartre. Terrasse iconique, chocolat chaud renommé.",
  price: 13,
  reservation_url: "https://lesdeuxmagots.fr",
  activity_type: "cafe",
  address: "6 Place Saint-Germain des Prés, 75006 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 7h30-1h",
  duration: 75,
  tagline: "Là où les existentialistes refaisaient le monde"
)

ActivityItem.create!(
  name: "Chambelland",
  description: "Boulangerie 100% sans gluten pionnière à Paris. Pain au levain, pâtisseries et sandwichs pour cœliaques et gourmands.",
  price: 8,
  reservation_url: "https://chambelland.com",
  activity_type: "cafe",
  address: "14 Rue Ternaux, 75011 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Sam: 8h-19h, Dim: 8h-15h",
  duration: 30,
  tagline: "Le sans gluten enfin délicieux"
)

ActivityItem.create!(
  name: "Astier",
  description: "Bistrot traditionnel du 11e avec plateau de fromages à volonté. Cave remarquable, ambiance authentique et chaleureuse.",
  price: 35,
  reservation_url: "",
  activity_type: "restaurant",
  address: "44 Rue Jean-Pierre Timbaud, 75011 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Ven: 12h-14h, 19h30-22h30",
  duration: 120,
  tagline: "Le fromage à volonté qui vaut le détour"
)

# ========================================
# 🎨 MUSÉES & GALERIES (25 items)
# ========================================

puts "Creating museums and galleries..."

ActivityItem.create!(
  name: "Musée d'Orsay",
  description: "Ancienne gare transformée en musée abritant la plus grande collection d'art impressionniste au monde. Monet, Renoir, Van Gogh...",
  price: 16,
  reservation_url: "https://www.musee-orsay.fr",
  activity_type: "museum",
  address: "1 Rue de la Légion d'Honneur, 75007 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Dim: 9h30-18h (Jeu jusqu'à 21h45)",
  duration: 180,
  tagline: "L'impressionnisme dans une gare majestueuse"
)

ActivityItem.create!(
  name: "Musée Rodin",
  description: "Hôtel particulier et jardin de sculptures présentant les chefs-d'œuvre de Rodin. Le Penseur, Le Baiser dans un cadre enchanteur.",
  price: 13,
  reservation_url: "https://www.musee-rodin.fr",
  activity_type: "museum",
  address: "77 Rue de Varenne, 75007 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Dim: 10h-18h30",
  duration: 120,
  tagline: "Sculptures monumentales dans un jardin secret"
)

ActivityItem.create!(
  name: "Centre Pompidou",
  description: "Architecture révolutionnaire abritant le plus grand musée d'art moderne d'Europe. Picasso, Matisse, Kandinsky et vue panoramique.",
  price: 15,
  reservation_url: "https://www.centrepompidou.fr",
  activity_type: "museum",
  address: "Place Georges-Pompidou, 75004 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mer-Lun: 11h-21h",
  duration: 150,
  tagline: "L'art moderne dans une machine à regarder"
)

ActivityItem.create!(
  name: "Musée de l'Orangerie",
  description: "Écrin intimiste des Nymphéas de Monet et collection Walter-Guillaume. Expérience immersive dans l'impressionnisme tardif.",
  price: 12,
  reservation_url: "https://www.musee-orangerie.fr",
  activity_type: "museum",
  address: "Jardin des Tuileries, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mer-Lun: 9h-18h",
  duration: 90,
  tagline: "Plonger dans les nymphéas de Monet"
)

ActivityItem.create!(
  name: "Musée Picasso",
  description: "La plus grande collection publique Picasso au monde dans un magnifique hôtel particulier du Marais. Toutes les périodes de l'artiste.",
  price: 14,
  reservation_url: "https://www.museepicassoparis.fr",
  activity_type: "museum",
  address: "5 Rue de Thorigny, 75003 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Ven: 10h30-18h, Sam-Dim: 9h30-18h",
  duration: 120,
  tagline: "Picasso comme vous ne l'avez jamais vu"
)

ActivityItem.create!(
  name: "Musée Jacquemart-André",
  description: "Hôtel particulier du Second Empire avec collection privée exceptionnelle. Fragonard, Botticelli dans un décor somptueux.",
  price: 17,
  reservation_url: "https://www.musee-jacquemart-andre.com",
  activity_type: "museum",
  address: "158 Boulevard Haussmann, 75008 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 10h-18h (Lun jusqu'à 20h30)",
  duration: 105,
  tagline: "Vivre comme un banquier du XIXe siècle"
)

ActivityItem.create!(
  name: "Atelier des Lumières",
  description: "Expérience immersive numérique projetant des œuvres d'art sur 3000m². Spectacle son et lumière époustouflant.",
  price: 17,
  reservation_url: "https://www.atelier-lumieres.com",
  activity_type: "art",
  address: "38 Rue Saint-Maur, 75011 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 10h-18h (Sam jusqu'à 22h)",
  duration: 75,
  tagline: "Entrer dans les tableaux géants"
)

ActivityItem.create!(
  name: "Musée Carnavalet",
  description: "Histoire de Paris de la préhistoire à nos jours dans deux hôtels particuliers rénovés. Gratuit et passionnant.",
  price: 0,
  reservation_url: "https://www.carnavalet.paris.fr",
  activity_type: "museum",
  address: "23 Rue de Sévigné, 75003 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Dim: 10h-18h",
  duration: 135,
  tagline: "L'histoire de Paris racontée par Paris"
)

ActivityItem.create!(
  name: "Palais de Tokyo",
  description: "Centre d'art contemporain expérimental avec expositions avant-gardistes. Architecture brutaliste, programmation audacieuse.",
  price: 12,
  reservation_url: "https://palaisdetokyo.com",
  activity_type: "art",
  address: "13 Avenue du Président Wilson, 75116 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mer-Lun: 12h-22h",
  duration: 120,
  tagline: "L'art qui bouscule les certitudes"
)

ActivityItem.create!(
  name: "Musée Marmottan Monet",
  description: "Collection intime consacrée à l'impressionnisme avec la plus grande collection de Monet, dont Impression Soleil Levant.",
  price: 14,
  reservation_url: "https://www.marmottan.fr",
  activity_type: "museum",
  address: "2 Rue Louis Boilly, 75016 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Dim: 10h-18h (Jeu jusqu'à 21h)",
  duration: 105,
  tagline: "Le Monet secret loin des foules"
)

ActivityItem.create!(
  name: "Petit Palais",
  description: "Musée des Beaux-Arts de la Ville de Paris avec collections de l'Antiquité au XXe siècle. Jardin intérieur apaisant, entrée gratuite.",
  price: 0,
  reservation_url: "https://www.petitpalais.paris.fr",
  activity_type: "museum",
  address: "Avenue Winston Churchill, 75008 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Dim: 10h-18h",
  duration: 120,
  tagline: "Le palace de l'art gratuit"
)

ActivityItem.create!(
  name: "Fondation Louis Vuitton",
  description: "Bâtiment spectaculaire de Frank Gehry abritant art moderne et contemporain. Architecture iconique dans le Bois de Boulogne.",
  price: 16,
  reservation_url: "https://www.fondationlouisvuitton.fr",
  activity_type: "art",
  address: "8 Avenue du Mahatma Gandhi, 75116 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Mer-Jeu: 11h-20h, Ven: 11h-21h, Sam-Dim: 10h-20h",
  duration: 150,
  tagline: "Le vaisseau spatial de l'art contemporain"
)

ActivityItem.create!(
  name: "Musée des Arts Décoratifs",
  description: "Design, mode et publicité de 1200 à nos jours. Collection exceptionnelle d'objets d'art et d'artisanat dans le Louvre.",
  price: 14,
  reservation_url: "https://madparis.fr",
  activity_type: "museum",
  address: "107 Rue de Rivoli, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Dim: 11h-18h",
  duration: 120,
  tagline: "L'histoire du design et de la mode"
)

ActivityItem.create!(
  name: "Musée du Quai Branly",
  description: "Arts et civilisations d'Afrique, Asie, Océanie et Amériques. Architecture de Jean Nouvel avec jardin vertical spectaculaire.",
  price: 12,
  reservation_url: "https://www.quaibranly.fr",
  activity_type: "museum",
  address: "37 Quai Jacques Chirac, 75007 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Mer-Dim: 10h30-19h, Jeu-Ven-Sam: 10h30-22h",
  duration: 135,
  tagline: "Le tour du monde des cultures"
)

ActivityItem.create!(
  name: "Musée Nissim de Camondo",
  description: "Hôtel particulier figé dans le temps avec mobilier XVIIIe siècle intact. Atmosphère intimiste d'une demeure habitée.",
  price: 12,
  reservation_url: "https://madparis.fr/nissim-de-camondo",
  activity_type: "museum",
  address: "63 Rue de Monceau, 75008 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mer-Dim: 10h-17h30",
  duration: 90,
  tagline: "Remonter le temps dans un appartement du XVIIIe"
)

ActivityItem.create!(
  name: "Musée de la Chasse et de la Nature",
  description: "Cabinet de curiosités contemporain mêlant art et taxidermie. Collections étonnantes dans un hôtel particulier baroque.",
  price: 10,
  reservation_url: "https://www.chassenature.org",
  activity_type: "museum",
  address: "62 Rue des Archives, 75003 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Dim: 11h-18h",
  duration: 90,
  tagline: "Le cabinet de curiosités du XXIe siècle"
)

ActivityItem.create!(
  name: "Musée Cognacq-Jay",
  description: "Collection intime XVIIIe dans un hôtel particulier du Marais. Fragonard, Boucher, mobilier raffiné. Gratuit et méconnu.",
  price: 0,
  reservation_url: "https://www.museecognacqjay.paris.fr",
  activity_type: "museum",
  address: "8 Rue Elzévir, 75003 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Dim: 10h-18h",
  duration: 75,
  tagline: "Le XVIIIe siècle dans l'intimité"
)

ActivityItem.create!(
  name: "Galerie Perrotin",
  description: "Galerie d'art contemporain majeure représentant artistes internationaux. Expositions ambitieuses, entrée libre.",
  price: 0,
  reservation_url: "https://www.perrotin.com",
  activity_type: "art",
  address: "76 Rue de Turenne, 75003 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Sam: 11h-19h",
  duration: 60,
  tagline: "L'avant-garde artistique mondiale"
)

ActivityItem.create!(
  name: "Musée Bourdelle",
  description: "Atelier-musée du sculpteur Antoine Bourdelle. Jardins cachés avec sculptures monumentales, atmosphère d'atelier préservée.",
  price: 0,
  reservation_url: "https://www.bourdelle.paris.fr",
  activity_type: "museum",
  address: "18 Rue Antoine Bourdelle, 75015 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Dim: 10h-18h",
  duration: 90,
  tagline: "L'atelier secret d'un maître sculpteur"
)

ActivityItem.create!(
  name: "Cité de l'Architecture",
  description: "Plus grand centre d'architecture au monde avec moulages monumentaux et galerie moderne. Vue sur Tour Eiffel depuis le café.",
  price: 9,
  reservation_url: "https://www.citedelarchitecture.fr",
  activity_type: "museum",
  address: "1 Place du Trocadéro, 75116 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mer-Lun: 11h-19h",
  duration: 120,
  tagline: "L'architecture française grandeur nature"
)

ActivityItem.create!(
  name: "Musée Gustave Moreau",
  description: "Atelier-appartement du peintre symboliste préservé tel quel. Spirales d'escaliers et profusion d'œuvres mystérieuses.",
  price: 7,
  reservation_url: "https://musee-moreau.fr",
  activity_type: "museum",
  address: "14 Rue de La Rochefoucauld, 75009 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mer-Lun: 10h-18h",
  duration: 75,
  tagline: "Plonger dans l'univers symboliste"
)

ActivityItem.create!(
  name: "Musée de la Vie Romantique",
  description: "Villa intimiste consacrée au romantisme avec jardin secret. Souvenirs de George Sand, salon de thé bucolique.",
  price: 0,
  reservation_url: "https://www.museevieromantique.paris.fr",
  activity_type: "museum",
  address: "16 Rue Chaptal, 75009 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Dim: 10h-18h",
  duration: 75,
  tagline: "Une oasis romantique loin de l'agitation"
)

ActivityItem.create!(
  name: "59 Rivoli",
  description: "Squat d'artistes devenu légal, 30 ateliers sur 6 étages ouverts au public. Création en direct, boutique d'art abordable.",
  price: 0,
  reservation_url: "https://www.59rivoli.org",
  activity_type: "art",
  address: "59 Rue de Rivoli, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mer-Dim: 13h-20h",
  duration: 60,
  tagline: "L'art underground au cœur de Paris"
)

ActivityItem.create!(
  name: "Institut du Monde Arabe",
  description: "Architecture contemporaine avec moucharabiehs mécaniques. Collections d'art arabe, terrasse panoramique et restaurant libanais.",
  price: 10,
  reservation_url: "https://www.imarabe.org",
  activity_type: "museum",
  address: "1 Rue des Fossés Saint-Bernard, 75005 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Ven: 10h-18h, Sam-Dim: 10h-19h",
  duration: 120,
  tagline: "L'Orient rencontre l'Occident"
)

ActivityItem.create!(
  name: "Maison de Victor Hugo",
  description: "Appartement de Victor Hugo sur la Place des Vosges. Manuscrits, dessins et souvenirs de l'écrivain. Gratuit.",
  price: 0,
  reservation_url: "https://www.maisonsvictorhugo.paris.fr",
  activity_type: "museum",
  address: "6 Place des Vosges, 75004 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Dim: 10h-18h",
  duration: 75,
  tagline: "Dans l'intimité du géant des lettres"
)

# ========================================
# 🏛️ MONUMENTS HISTORIQUES (20 items)
# ========================================

puts "Creating historical monuments..."

ActivityItem.create!(
  name: "Sainte-Chapelle",
  description: "Joyau gothique du XIIIe siècle avec 15 vitraux monumentaux. Lumière magique et architecture vertigo-inducing.",
  price: 11,
  reservation_url: "https://www.sainte-chapelle.fr",
  activity_type: "monument",
  address: "8 Boulevard du Palais, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 9h-17h (jusqu'à 19h en été)",
  duration: 45,
  tagline: "La cathédrale de verre et de lumière"
)

ActivityItem.create!(
  name: "Panthéon",
  description: "Temple républicain abritant les tombes de Voltaire, Rousseau, Hugo, Curie. Pendule de Foucault et crypte monumentale.",
  price: 11,
  reservation_url: "https://www.paris-pantheon.fr",
  activity_type: "monument",
  address: "Place du Panthéon, 75005 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 10h-18h30",
  duration: 90,
  tagline: "Là où reposent les grands de la République"
)

ActivityItem.create!(
  name: "Arc de Triomphe",
  description: "Monument napoléonien au sommet de l'avenue des Champs-Élysées. Vue panoramique à 360° sur Paris depuis le toit.",
  price: 13,
  reservation_url: "https://www.paris-arc-de-triomphe.fr",
  activity_type: "monument",
  address: "Place Charles de Gaulle, 75008 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 10h-22h30",
  duration: 75,
  tagline: "L'étoile qui rayonne sur Paris"
)

ActivityItem.create!(
  name: "Conciergerie",
  description: "Palais médiéval transformé en prison révolutionnaire. Cellule de Marie-Antoinette et salles gothiques impressionnantes.",
  price: 11,
  reservation_url: "https://www.conciergerie.fr",
  activity_type: "monument",
  address: "2 Boulevard du Palais, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 9h30-18h",
  duration: 75,
  tagline: "Des rois à la Révolution"
)

ActivityItem.create!(
  name: "Tour Montparnasse",
  description: "Gratte-ciel iconique des années 70 avec observatoire panoramique au 56e étage. Vue imprenable sur la Tour Eiffel.",
  price: 18,
  reservation_url: "https://www.tourmontparnasse56.com",
  activity_type: "viewpoint",
  address: "33 Avenue du Maine, 75015 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 9h30-23h30",
  duration: 60,
  tagline: "Paris vu d'en haut sans faire la queue"
)

ActivityItem.create!(
  name: "Basilique du Sacré-Cœur",
  description: "Basilique romano-byzantine couronnant Montmartre. Mosaïques dorées, crypte et vue spectaculaire gratuite depuis le parvis.",
  price: 0,
  reservation_url: "https://www.sacre-coeur-montmartre.com",
  activity_type: "monument",
  address: "35 Rue du Chevalier de la Barre, 75018 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 6h-22h30 (dôme 9h-19h)",
  duration: 75,
  tagline: "Le phare blanc de Montmartre"
)

ActivityItem.create!(
  name: "Opéra Garnier",
  description: "Chef-d'œuvre baroque Napoléon III avec grand escalier, plafond de Chagall et fantôme légendaire. Visites guidées passionnantes.",
  price: 14,
  reservation_url: "https://www.operadeparis.fr",
  activity_type: "monument",
  address: "Place de l'Opéra, 75009 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 10h-16h30 (sauf représentations)",
  duration: 90,
  tagline: "Le palais du Fantôme de l'Opéra"
)

ActivityItem.create!(
  name: "Les Invalides",
  description: "Complexe militaire abritant le tombeau de Napoléon sous le dôme doré. Musée de l'Armée et jardins à la française.",
  price: 14,
  reservation_url: "https://www.musee-armee.fr",
  activity_type: "monument",
  address: "129 Rue de Grenelle, 75007 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 10h-18h",
  duration: 120,
  tagline: "Napoléon repose sous l'or"
)

ActivityItem.create!(
  name: "Catacombes de Paris",
  description: "Ossuaire souterrain contenant les restes de 6 millions de Parisiens. Dédale macabre à 20m sous terre, réservation obligatoire.",
  price: 15,
  reservation_url: "https://www.catacombes.paris.fr",
  activity_type: "monument",
  address: "1 Avenue du Colonel Henri Rol-Tanguy, 75014 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Dim: 9h45-20h30",
  duration: 75,
  tagline: "L'empire de la mort sous Paris"
)

ActivityItem.create!(
  name: "Notre-Dame de Paris",
  description: "Cathédrale gothique en cours de restauration après l'incendie de 2019. Parvis accessible, réouverture prévue fin 2024.",
  price: 0,
  reservation_url: "https://www.notredamedeparis.fr",
  activity_type: "monument",
  address: "6 Parvis Notre-Dame, 75004 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Parvis accessible 24h/24",
  duration: 30,
  tagline: "Le phénix qui renaît de ses cendres"
)

ActivityItem.create!(
  name: "Château de Vincennes",
  description: "Forteresse médiévale aux portes de Paris avec donjon du XIVe siècle. Moins touristique que Versailles, tout aussi impressionnant.",
  price: 10,
  reservation_url: "https://www.chateau-vincennes.fr",
  activity_type: "monument",
  address: "Avenue de Paris, 94300 Vincennes",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 10h-17h (jusqu'à 18h en été)",
  duration: 105,
  tagline: "Le Versailles médiéval méconnu"
)

ActivityItem.create!(
  name: "Tour Eiffel",
  description: "Dame de Fer emblématique de Paris. 330m de hauteur, 3 étages accessibles, illuminations scintillantes chaque heure la nuit.",
  price: 28,
  reservation_url: "https://www.toureiffel.paris",
  activity_type: "monument",
  address: "Champ de Mars, 5 Avenue Anatole France, 75007 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 9h30-23h45",
  duration: 120,
  tagline: "L'icône qui scintille pour vous"
)

ActivityItem.create!(
  name: "Arènes de Lutèce",
  description: "Amphithéâtre gallo-romain du Ier siècle caché dans le 5e arrondissement. Gratuit, paisible, idéal pour pique-niquer.",
  price: 0,
  reservation_url: "",
  activity_type: "monument",
  address: "49 Rue Monge, 75005 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 8h-20h (selon saison)",
  duration: 45,
  tagline: "Les gradins romains oubliés de Paris"
)

ActivityItem.create!(
  name: "Palais Royal",
  description: "Jardin secret avec colonnes de Buren, galeries marchandes d'époque et terrasse du Grand Véfour. Havre de paix au cœur de Paris.",
  price: 0,
  reservation_url: "",
  activity_type: "monument",
  address: "8 Rue de Montpensier, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 7h-22h30",
  duration: 45,
  tagline: "Le jardin rayé au cœur du pouvoir"
)

ActivityItem.create!(
  name: "Église Saint-Sulpice",
  description: "Église baroque monumentale avec fresques de Delacroix et gnomon du Da Vinci Code. Architecture impressionnante, entrée libre.",
  price: 0,
  reservation_url: "",
  activity_type: "monument",
  address: "2 Rue Palatine, 75006 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 7h30-19h30",
  duration: 45,
  tagline: "L'église du Da Vinci Code"
)

ActivityItem.create!(
  name: "Église Saint-Eustache",
  description: "Mélange unique de gothique et renaissance aux Halles. Orgue monumental, concerts réguliers, architecture spectaculaire.",
  price: 0,
  reservation_url: "https://www.saint-eustache.org",
  activity_type: "monument",
  address: "2 Impasse Saint-Eustache, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Ven: 9h30-19h, Sam-Dim: 9h-19h",
  duration: 45,
  tagline: "La cathédrale cachée des Halles"
)

ActivityItem.create!(
  name: "Pont Alexandre III",
  description: "Le plus élégant pont de Paris avec lampadaires dorés Art Nouveau. Parfait pour photos avec vue sur les Invalides.",
  price: 0,
  reservation_url: "",
  activity_type: "monument",
  address: "Pont Alexandre III, 75008 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "24h/24",
  duration: 20,
  tagline: "Le pont carte postale de Paris"
)

ActivityItem.create!(
  name: "Crypte Archéologique",
  description: "Site archéologique sous le parvis de Notre-Dame révélant 2000 ans d'histoire parisienne. Vestiges romains et médiévaux.",
  price: 9,
  reservation_url: "https://www.crypte.paris.fr",
  activity_type: "monument",
  address: "7 Parvis Notre-Dame, 75004 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Dim: 10h-18h",
  duration: 60,
  tagline: "Paris couche par couche sous vos pieds"
)

ActivityItem.create!(
  name: "Pavillon de l'Arsenal",
  description: "Centre d'architecture et d'urbanisme présentant l'évolution de Paris. Maquette géante interactive, expositions gratuites.",
  price: 0,
  reservation_url: "https://www.pavillon-arsenal.com",
  activity_type: "monument",
  address: "21 Boulevard Morland, 75004 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Dim: 11h-19h",
  duration: 75,
  tagline: "Comprendre comment Paris s'est construit"
)

ActivityItem.create!(
  name: "La Coulée Verte",
  description: "Promenade plantée de 4,5km sur ancienne voie ferrée. Du Bastille au Bois de Vincennes, street art et jardins suspendus.",
  price: 0,
  reservation_url: "",
  activity_type: "outdoor",
  address: "1 Coulée Verte René-Dumont, 75012 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 8h-20h30 (selon saison)",
  duration: 90,
  tagline: "La High Line avant la High Line"
)

# ========================================
# 🎭 ÉVÉNEMENTS CULTURELS (15 items)
# ========================================

puts "Creating cultural events..."

ActivityItem.create!(
  name: "Concert à la Philharmonie",
  description: "Salle de concert au design futuriste avec acoustique exceptionnelle. Orchestre de Paris, concerts classiques et contemporains.",
  price: 35,
  reservation_url: "https://philharmoniedeparis.fr",
  activity_type: "concert",
  address: "221 Avenue Jean Jaurès, 75019 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Horaires variables selon programme",
  duration: 150,
  tagline: "Le vaisseau spatial de la musique classique"
)

ActivityItem.create!(
  name: "Soirée au Crazy Horse",
  description: "Cabaret mythique avec spectacle de nu artistique et jeux de lumière avant-gardistes. Champagne et glamour parisien.",
  price: 90,
  reservation_url: "https://lecrazyhorseparis.com",
  activity_type: "show",
  address: "12 Avenue George V, 75008 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Spectacles à 19h et 21h30",
  duration: 90,
  tagline: "L'art du nu réinventé"
)

ActivityItem.create!(
  name: "Cinéma Le Grand Rex",
  description: "Plus grande salle de cinéma d'Europe avec décor Art Déco monumental. Avant-premières et visite des coulisses possible.",
  price: 12,
  reservation_url: "https://www.legrandrex.com",
  activity_type: "cinema",
  address: "1 Boulevard Poissonnière, 75002 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Séances de 10h à minuit",
  duration: 150,
  tagline: "Le temple du 7ème art parisien"
)

ActivityItem.create!(
  name: "Moulin Rouge",
  description: "Cabaret légendaire avec spectacle Féerie et french cancan. Strass, plumes et champagne dans l'ambiance Belle Époque.",
  price: 120,
  reservation_url: "https://www.moulinrouge.fr",
  activity_type: "show",
  address: "82 Boulevard de Clichy, 75018 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Dîner-spectacle 19h, Spectacle seul 21h et 23h",
  duration: 120,
  tagline: "Le french cancan qui fait rêver le monde"
)

ActivityItem.create!(
  name: "Jazz au Duc des Lombards",
  description: "Club de jazz intimiste de Saint-Germain. Programmation pointue, artistes internationaux, ambiance feutrée et cave voûtée.",
  price: 25,
  reservation_url: "https://www.ducdeslombards.com",
  activity_type: "concert",
  address: "42 Rue des Lombards, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Concerts à 20h et 22h",
  duration: 120,
  tagline: "Le temple du jazz parisien"
)

ActivityItem.create!(
  name: "Comédie-Française",
  description: "Théâtre national avec troupe permanente jouant le répertoire classique. Molière, Racine dans la salle Richelieu historique.",
  price: 30,
  reservation_url: "https://www.comedie-francaise.fr",
  activity_type: "theater",
  address: "Place Colette, 75001 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Représentations en soirée et matinée dim",
  duration: 180,
  tagline: "La maison de Molière depuis 1680"
)

ActivityItem.create!(
  name: "New Morning",
  description: "Salle de concert jazz et world music mythique. Acoustique parfaite, programmation éclectique, bar convivial.",
  price: 28,
  reservation_url: "https://www.newmorning.com",
  activity_type: "concert",
  address: "7-9 Rue des Petites Écuries, 75010 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Concerts à 20h30",
  duration: 135,
  tagline: "Là où le jazz vit chaque nuit"
)

ActivityItem.create!(
  name: "Cinéma La Pagode",
  description: "Salle de cinéma Art et Essai dans une pagode japonaise du XIXe. Jardin zen, programmation exigeante, architecture unique.",
  price: 11,
  reservation_url: "https://www.cinemaspagode.fr",
  activity_type: "cinema",
  address: "57bis Rue de Babylone, 75007 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Séances de 14h à 22h",
  duration: 135,
  tagline: "Voir un film dans une pagode"
)

ActivityItem.create!(
  name: "Théâtre de l'Odéon",
  description: "Théâtre national avec programmation contemporaine audacieuse. Architecture néoclassique, auteurs vivants et metteurs en scène innovants.",
  price: 28,
  reservation_url: "https://www.theatre-odeon.eu",
  activity_type: "theater",
  address: "Place de l'Odéon, 75006 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Représentations soir et week-end",
  duration: 150,
  tagline: "Le théâtre qui bouscule les codes"
)

ActivityItem.create!(
  name: "L'Olympia",
  description: "Salle de concert mythique ayant accueilli tous les grands. Édith Piaf, Brel, aujourd'hui concerts pop-rock et variété.",
  price: 45,
  reservation_url: "https://www.olympiahall.com",
  activity_type: "concert",
  address: "28 Boulevard des Capucines, 75009 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Horaires selon programmation",
  duration: 150,
  tagline: "La salle rouge où sont nées les légendes"
)

ActivityItem.create!(
  name: "Point Éphémère",
  description: "Lieu culturel alternatif au bord du Canal Saint-Martin. Concerts, expositions, clubbing et terrasse l'été.",
  price: 15,
  reservation_url: "https://www.pointephemere.org",
  activity_type: "concert",
  address: "200 Quai de Valmy, 75010 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mer-Dim: 12h-2h",
  duration: 180,
  tagline: "La culture underground au bord de l'eau"
)

ActivityItem.create!(
  name: "Opéra Bastille",
  description: "Opéra moderne avec acoustique exceptionnelle. Productions ambitieuses d'opéra et ballet, visibilité parfaite de tous les sièges.",
  price: 50,
  reservation_url: "https://www.operadeparis.fr",
  activity_type: "show",
  address: "Place de la Bastille, 75012 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Représentations en soirée",
  duration: 210,
  tagline: "L'opéra populaire du peuple"
)

ActivityItem.create!(
  name: "Café de la Danse",
  description: "Salle de concert intimiste dans le 11e. Rock indé, électro, chanson française. Ambiance proximité avec les artistes.",
  price: 22,
  reservation_url: "https://cafedeladanse.com",
  activity_type: "concert",
  address: "5 Passage Louis-Philippe, 75011 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Concerts à 20h",
  duration: 120,
  tagline: "À deux mètres de la scène"
)

ActivityItem.create!(
  name: "Shakespeare and Company Readings",
  description: "Lectures et rencontres d'auteurs dans la librairie anglophone iconique. Gratuit, ambiance bohème littéraire.",
  price: 0,
  reservation_url: "https://shakespeareandcompany.com",
  activity_type: "cultural",
  address: "37 Rue de la Bûcherie, 75005 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 10h-22h, events variables",
  duration: 90,
  tagline: "Là où les mots prennent vie"
)

ActivityItem.create!(
  name: "Parc de la Villette - Cinéma en plein air",
  description: "Projection de films en plein air l'été sur écran géant. Ambiance pique-nique, classiques et nouveautés, gratuit ou petit prix.",
  price: 5,
  reservation_url: "https://lavillette.com",
  activity_type: "cinema",
  address: "211 Avenue Jean Jaurès, 75019 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Juil-Août: à la tombée de la nuit",
  duration: 150,
  tagline: "Le cinéma sous les étoiles parisiennes"
)

# ========================================
# ⚽ ACTIVITÉS SPORTIVES & LOISIRS (10 items)
# ========================================

puts "Creating sports and leisure activities..."

ActivityItem.create!(
  name: "Croisière sur la Seine",
  description: "Bateau-mouche commenté passant devant tous les monuments. Tour Eiffel, Notre-Dame, Louvre illuminés en soirée.",
  price: 16,
  reservation_url: "https://www.bateaux-parisiens.com",
  activity_type: "cruise",
  address: "Port de la Bourdonnais, 75007 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Départs toutes les 30min de 10h à 22h",
  duration: 70,
  tagline: "Paris vu depuis ses eaux"
)

ActivityItem.create!(
  name: "Ballon de Paris",
  description: "Montgolfière captive montant à 150m d'altitude. Vue panoramique à 360° sur Paris, sensations douces, accessible PMR.",
  price: 16,
  reservation_url: "https://ballondeparis.com",
  activity_type: "outdoor",
  address: "Parc André Citroën, 75015 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mer-Dim: 9h-19h (selon météo)",
  duration: 30,
  tagline: "S'envoler au-dessus de Paris"
)

ActivityItem.create!(
  name: "Vélo le long du Canal Saint-Martin",
  description: "Balade vélo de Bastille à La Villette le long du canal. Écluses pittoresques, street art, bars et cafés branchés.",
  price: 15,
  reservation_url: "https://velib-metropole.fr",
  activity_type: "outdoor",
  address: "Départ Place de la Bastille, 75011 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "24h/24 (location Vélib)",
  duration: 120,
  tagline: "Paris au rythme des péniches"
)

ActivityItem.create!(
  name: "Piscine Joséphine Baker",
  description: "Piscine flottante sur la Seine avec toit ouvrant l'été. Bassins, solarium, vue sur Bercy. Expérience unique.",
  price: 7,
  reservation_url: "https://www.paris.fr/equipements/piscine-josephine-baker-1752",
  activity_type: "sport",
  address: "Quai François Mauriac, 75013 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Mar-Ven: 13h-20h, Sam-Dim: 10h-20h",
  duration: 120,
  tagline: "Nager sur la Seine"
)

ActivityItem.create!(
  name: "Jardin du Luxembourg",
  description: "Parc à la française avec chaises vertes iconiques. Bassin pour voiliers miniatures, tennis, jogging, échecs en plein air.",
  price: 0,
  reservation_url: "",
  activity_type: "outdoor",
  address: "Rue de Vaugirard, 75006 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 7h30-21h30 (selon saison)",
  duration: 90,
  tagline: "Le jardin où flâner devient un art"
)

ActivityItem.create!(
  name: "Parc des Buttes-Chaumont",
  description: "Parc vallonné avec lac, cascade, temple grec au sommet. Vue sur Montmartre, grottes, ponts suspendus. Idéal pique-nique.",
  price: 0,
  reservation_url: "",
  activity_type: "outdoor",
  address: "1 Rue Botzaris, 75019 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Dim: 7h-22h (selon saison)",
  duration: 120,
  tagline: "Le parc romantique aux faux airs de montagne"
)

ActivityItem.create!(
  name: "Roller à Rollers & Coquillages",
  description: "Randonnée roller tous niveaux chaque vendredi soir. 20-30km à travers Paris de nuit, ambiance festive et sécurisée.",
  price: 0,
  reservation_url: "https://www.pari-roller.com",
  activity_type: "sport",
  address: "Départ Place Raoul Dautry (Montparnasse), 75015 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "Ven: départ 22h",
  duration: 180,
  tagline: "Paris en roller by night"
)

ActivityItem.create!(
  name: "MurMur Escalade Pantin",
  description: "Salle d'escalade de bloc moderne. 1500m² de murs, problèmes renouvelés, café cosy. Débutants et confirmés bienvenus.",
  price: 16,
  reservation_url: "https://murmur.fr",
  activity_type: "sport",
  address: "55 Rue Cartier Bresson, 93500 Pantin",
  city: "Paris",
  country: "France",
  opening_hours: "Lun-Ven: 10h-23h, Sam-Dim: 10h-20h",
  duration: 150,
  tagline: "Grimper dans l'ancien France Télécom"
)

ActivityItem.create!(
  name: "Bois de Vincennes",
  description: "Plus grand espace vert parisien avec 4 lacs, zoo, château, théâtre de verdure. Vélo, barque, jogging, pique-nique.",
  price: 0,
  reservation_url: "",
  activity_type: "outdoor",
  address: "Route de la Pyramide, 75012 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "24h/24",
  duration: 180,
  tagline: "La forêt urbaine de l'est parisien"
)

ActivityItem.create!(
  name: "Berges de Seine",
  description: "Promenade piétonne le long de la rive gauche. Activités gratuites l'été, food trucks, guinguettes, pédalos. Ambiance festive.",
  price: 0,
  reservation_url: "",
  activity_type: "outdoor",
  address: "Quai Anatole France à Quai de la Gare, 75007 Paris",
  city: "Paris",
  country: "France",
  opening_hours: "24h/24",
  duration: 120,
  tagline: "Paris plage toute l'année"
)


puts "🎉 Activity items are created.\n"


# Create recommendation for Trip 3
puts "📋 Creating recommendations..."

recommendation = Recommendation.create!(
  trip: trip3,
  accepted: nil,
  system_prompt: "Generate cultural and food activities for Tokyo in summer"
)

RecommendationItem.create!(
  recommendation: recommendation,
  activity_item: ActivityItem.find_by(name: "Musée d'Orsay")
)

RecommendationItem.create!(
  recommendation: recommendation,
  activity_item: ActivityItem.find_by(name: "Le Comptoir du Relais")
)

RecommendationItem.create!(
  recommendation: recommendation,
  activity_item: ActivityItem.find_by(name: "Tour Eiffel")
)

RecommendationItem.create!(
  recommendation: recommendation,
  activity_item: ActivityItem.find_by(name: "Sainte-Chapelle")
)

puts "✅ Trip 3 created with #{trip3.user_trip_statuses.count} participants and #{recommendation.recommendation_items.count} recommendations"

# ==============================================
# TRIP 2: Adding finalized recommendation
# ==============================================
puts "\n💡 Creating finalized recommendation for Trip 2..."

recommendation_paris = Recommendation.create!(
  trip: trip2,
  accepted: true,
  system_prompt: "Generate cultural and gastronomy activities for Paris based on user preferences"
)

# Create recommendation items (without likes - votes are tracked separately)
item1 = RecommendationItem.create!(
  recommendation: recommendation_paris,
  activity_item: ActivityItem.find_by(name: "Musée d'Orsay")
)

item2 = RecommendationItem.create!(
  recommendation: recommendation_paris,
  activity_item: ActivityItem.find_by(name: "Le Comptoir du Relais")
)

item3 = RecommendationItem.create!(
  recommendation: recommendation_paris,
  activity_item: ActivityItem.find_by(name: "Café de Flore")
)

item4 = RecommendationItem.create!(
  recommendation: recommendation_paris,
  activity_item: ActivityItem.find_by(name: "Sainte-Chapelle")
)

item5 = RecommendationItem.create!(
  recommendation: recommendation_paris,
  activity_item: ActivityItem.find_by(name: "Septime")
)

item6 = RecommendationItem.create!(
  recommendation: recommendation_paris,
  activity_item: ActivityItem.find_by(name: "Centre Pompidou")
)

item7 = RecommendationItem.create!(
  recommendation: recommendation_paris,
  activity_item: ActivityItem.find_by(name: "L'As du Fallafel")
)

item8 = RecommendationItem.create!(
  recommendation: recommendation_paris,
  activity_item: ActivityItem.find_by(name: "Musée Rodin")
)

# Create sample votes for Diana (Trip 2 creator)
RecommendationVote.create!(user_trip_status: uts_diana, recommendation_item: item1, like: true)
RecommendationVote.create!(user_trip_status: uts_diana, recommendation_item: item2, like: true)
RecommendationVote.create!(user_trip_status: uts_diana, recommendation_item: item3, like: false)
RecommendationVote.create!(user_trip_status: uts_diana, recommendation_item: item4, like: true)
RecommendationVote.create!(user_trip_status: uts_diana, recommendation_item: item5, like: true)
RecommendationVote.create!(user_trip_status: uts_diana, recommendation_item: item6, like: nil)
RecommendationVote.create!(user_trip_status: uts_diana, recommendation_item: item7, like: true)
RecommendationVote.create!(user_trip_status: uts_diana, recommendation_item: item8, like: nil)

puts "✅ Trip 2 finalized recommendation created with #{recommendation_paris.recommendation_items.count} items"

# ==============================================
# TRIP 2: Creating completed itinerary
# ==============================================
puts "\n📅 Creating completed itinerary for Trip 2..."

itinerary_paris = Itinerary.create!(
  trip: trip2,
  system_prompt: "Generate a 3-day cultural and gastronomy itinerary for Paris"
)

# Day 1 - 2026-09-26
ItineraryItem.create!(
  itinerary: itinerary_paris,
  activity_item: ActivityItem.find_by(name: "Holybelly"),
  date: "2026-09-26",
  slot: "morning",
  time: "09:00",
  position: "1"
)

ItineraryItem.create!(
  itinerary: itinerary_paris,
  activity_item: ActivityItem.find_by(name: "Sainte-Chapelle"),
  date: "2026-09-26",
  slot: "morning",
  time: "11:00",
  position: "2"
)

ItineraryItem.create!(
  itinerary: itinerary_paris,
  activity_item: ActivityItem.find_by(name: "L'As du Fallafel"),
  date: "2026-09-26",
  slot: "afternoon",
  time: "13:00",
  position: "3"
)

ItineraryItem.create!(
  itinerary: itinerary_paris,
  activity_item: ActivityItem.find_by(name: "Musée Picasso"),
  date: "2026-09-26",
  slot: "afternoon",
  time: "15:00",
  position: "4"
)

ItineraryItem.create!(
  itinerary: itinerary_paris,
  activity_item: ActivityItem.find_by(name: "Le Comptoir du Relais"),
  date: "2026-09-26",
  slot: "evening",
  time: "19:30",
  position: "5"
)

# Day 2 - 2026-09-27
ItineraryItem.create!(
  itinerary: itinerary_paris,
  activity_item: ActivityItem.find_by(name: "Café Kitsuné"),
  date: "2026-09-27",
  slot: "morning",
  time: "09:00",
  position: "1"
)

ItineraryItem.create!(
  itinerary: itinerary_paris,
  activity_item: ActivityItem.find_by(name: "Musée d'Orsay"),
  date: "2026-09-27",
  slot: "morning",
  time: "10:00",
  position: "2"
)

ItineraryItem.create!(
  itinerary: itinerary_paris,
  activity_item: ActivityItem.find_by(name: "Angelina"),
  date: "2026-09-27",
  slot: "afternoon",
  time: "13:00",
  position: "3"
)

ItineraryItem.create!(
  itinerary: itinerary_paris,
  activity_item: ActivityItem.find_by(name: "Musée Rodin"),
  date: "2026-09-27",
  slot: "afternoon",
  time: "15:00",
  position: "4"
)

ItineraryItem.create!(
  itinerary: itinerary_paris,
  activity_item: ActivityItem.find_by(name: "Septime"),
  date: "2026-09-27",
  slot: "evening",
  time: "19:30",
  position: "5"
)

# Day 3 - 2026-09-28
ItineraryItem.create!(
  itinerary: itinerary_paris,
  activity_item: ActivityItem.find_by(name: "Claus"),
  date: "2026-09-28",
  slot: "morning",
  time: "09:00",
  position: "1"
)

ItineraryItem.create!(
  itinerary: itinerary_paris,
  activity_item: ActivityItem.find_by(name: "Centre Pompidou"),
  date: "2026-09-28",
  slot: "morning",
  time: "11:00",
  position: "2"
)

ItineraryItem.create!(
  itinerary: itinerary_paris,
  activity_item: ActivityItem.find_by(name: "Breizh Café"),
  date: "2026-09-28",
  slot: "afternoon",
  time: "13:00",
  position: "3"
)

ItineraryItem.create!(
  itinerary: itinerary_paris,
  activity_item: ActivityItem.find_by(name: "Croisière sur la Seine"),
  date: "2026-09-28",
  slot: "afternoon",
  time: "15:00",
  position: "4"
)

ItineraryItem.create!(
  itinerary: itinerary_paris,
  activity_item: ActivityItem.find_by(name: "Frenchie"),
  date: "2026-09-28",
  slot: "evening",
  time: "19:00",
  position: "5"
)

puts "✅ Itinerary created with #{itinerary_paris.itinerary_items.count} activities over 3 days"

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
puts "\n✨ You can now test your trips:"
puts "  • Trip 1 (#{trip1.name}): ID #{trip1.id} - All pending invitations"
puts "  • Trip 2 (#{trip2.name}): ID #{trip2.id} - Mixed statuses + Finalized recommendation + Complete itinerary (3 days)"
puts "  • Trip 3 (#{trip3.name}): ID #{trip3.id} - All reviewing suggestions"
puts "="*50

puts "\n🧪 Creating test data for recommendations..."

# Créer un trip de test
trip = Trip.create!(
  name: "Paris Weekend",
  destination: "Paris",
  start_date: "2025-12-15",
  end_date: "2025-12-17",
  trip_type: "weekend"
)

# Créer 2 utilisateurs
user1 = User.create!(
  first_name: "Alice",
  last_name: "Martin",
  email: "alice@test.com",
  password: "password"
)

user2 = User.create!(
  first_name: "Bob",
  last_name: "Dubois",
  email: "bob@test.com",
  password: "password"
)

# Créer les UserTripStatus avec form_filled: true
# Note: On doit stocker les UserTripStatus dans des variables pour pouvoir créer les PreferencesForm associés après
uts_user1 = UserTripStatus.create!(
  user: user1,
  trip: trip,
  form_filled: true,
  role: "creator",
  trip_status: "active",
  is_invited: false,
  recommendation_reviewed: false,
  invitation_accepted: true
)

uts_user2 = UserTripStatus.create!(
  user: user2,
  trip: trip,
  form_filled: true,
  role: "participant",
  trip_status: "active",
  is_invited: true,
  recommendation_reviewed: false,
  invitation_accepted: true
)

# Créer les PreferencesForm pour ces utilisateurs
# Important: Si form_filled est true, il FAUT créer un PreferencesForm sinon generate_recommendations_if_ready va planter
PreferencesForm.create!(
  user_trip_status: uts_user1,
  travel_pace: "moderate",
  budget: 1500,
  interests: "museums, food, history",
  activity_types: "cultural, food"
)

PreferencesForm.create!(
  user_trip_status: uts_user2,
  travel_pace: "relaxed",
  budget: 1200,
  interests: "cafes, shopping, architecture",
  activity_types: "shopping, cultural"
)

# Générer les recommendations automatiquement
puts "Generating recommendations for trip #{trip.id}..."
trip.generate_recommendations_if_ready

puts "✅ Test trip created with ID: #{trip.id}"
puts "✅ #{trip.recommendations.count} recommendation(s) generated"
puts "✅ #{trip.recommendations.first&.recommendation_items&.count} recommendation items created"

# ==============================================
# TRIP 5: Votes don't match (accepted: false)
# ==============================================
puts "\n❌ Creating Trip 5: Barcelona Adventure (Votes don't match)..."

trip5 = Trip.create!(
  name: "Barcelona Adventure",
  destination: "Barcelona, Spain",
  start_date: "2026-05-10",
  end_date: "2026-05-14",
  trip_type: "adventure"
)

# Create two users with completed preferences and reviews
user_julia = User.create!(
  first_name: "Julia",
  last_name: "Garcia",
  email: "julia@yugo.com",
  password: "password123"
)

user_marco = User.create!(
  first_name: "Marco",
  last_name: "Silva",
  email: "marco@yugo.com",
  password: "password123"
)

# Julia - creator (all done, reviewed)
uts_julia = UserTripStatus.create!(
  user: user_julia,
  trip: trip5,
  role: "creator",
  trip_status: "reviewed",
  is_invited: true,
  invitation_accepted: true,
  form_filled: true,
  recommendation_reviewed: true
)

PreferencesForm.create!(
  user_trip_status: uts_julia,
  travel_pace: "intense",
  budget: 1800,
  interests: { culture: 90, food: 80, nightlife: 70, nature: 40, shopping: 30, sport: 60 },
  activity_types: ["Museums", "Gastronomy", "Architecture"]
)

# Marco - participant (all done, reviewed)
uts_marco = UserTripStatus.create!(
  user: user_marco,
  trip: trip5,
  role: "participant",
  trip_status: "reviewed",
  is_invited: true,
  invitation_accepted: true,
  form_filled: true,
  recommendation_reviewed: true
)

PreferencesForm.create!(
  user_trip_status: uts_marco,
  travel_pace: "moderate",
  budget: 1500,
  interests: { culture: 60, food: 70, nightlife: 50, nature: 80, shopping: 40, sport: 90 },
  activity_types: ["Parks", "Sport events", "Photography"]
)

# Create recommendation with accepted: false (votes don't match)
recommendation_barcelona = Recommendation.create!(
  trip: trip5,
  accepted: false,
  system_prompt: "Generate cultural and sport activities for Barcelona"
)

# Create recommendation items
item_b1 = RecommendationItem.create!(
  recommendation: recommendation_barcelona,
  activity_item: ActivityItem.find_by(name: "Musée d'Orsay") # Using Paris activities for demo
)

item_b2 = RecommendationItem.create!(
  recommendation: recommendation_barcelona,
  activity_item: ActivityItem.find_by(name: "Centre Pompidou")
)

item_b3 = RecommendationItem.create!(
  recommendation: recommendation_barcelona,
  activity_item: ActivityItem.find_by(name: "Tour Eiffel")
)

item_b4 = RecommendationItem.create!(
  recommendation: recommendation_barcelona,
  activity_item: ActivityItem.find_by(name: "Sainte-Chapelle")
)

# Create votes for both users (mostly dislikes to simulate disagreement)
RecommendationVote.create!(user_trip_status: uts_julia, recommendation_item: item_b1, like: true)
RecommendationVote.create!(user_trip_status: uts_julia, recommendation_item: item_b2, like: false)
RecommendationVote.create!(user_trip_status: uts_julia, recommendation_item: item_b3, like: false)
RecommendationVote.create!(user_trip_status: uts_julia, recommendation_item: item_b4, like: true)

RecommendationVote.create!(user_trip_status: uts_marco, recommendation_item: item_b1, like: false)
RecommendationVote.create!(user_trip_status: uts_marco, recommendation_item: item_b2, like: false)
RecommendationVote.create!(user_trip_status: uts_marco, recommendation_item: item_b3, like: true)
RecommendationVote.create!(user_trip_status: uts_marco, recommendation_item: item_b4, like: false)

puts "✅ Trip 5 created with #{trip5.user_trip_statuses.count} participants - Votes DON'T match (accepted: false)"

# ==============================================
# TRIP 6: Votes match (accepted: true)
# ==============================================
puts "\n✅ Creating Trip 6: Rome Discovery (Votes match!)..."

trip6 = Trip.create!(
  name: "Rome Discovery",
  destination: "Rome, Italy",
  start_date: "2026-06-20",
  end_date: "2026-06-25",
  trip_type: "cultural"
)

# Create two users with completed preferences and reviews
user_sophia = User.create!(
  first_name: "Sophia",
  last_name: "Rossi",
  email: "sophia@yugo.com",
  password: "password123"
)

user_luca = User.create!(
  first_name: "Luca",
  last_name: "Bianchi",
  email: "luca@yugo.com",
  password: "password123"
)

# Sophia - creator (all done, reviewed)
uts_sophia = UserTripStatus.create!(
  user: user_sophia,
  trip: trip6,
  role: "creator",
  trip_status: "reviewed",
  is_invited: true,
  invitation_accepted: true,
  form_filled: true,
  recommendation_reviewed: true
)

PreferencesForm.create!(
  user_trip_status: uts_sophia,
  travel_pace: "moderate",
  budget: 2000,
  interests: { culture: 95, food: 85, nightlife: 50, nature: 60, shopping: 40, sport: 30 },
  activity_types: ["Museums", "Architecture", "Gastronomy"]
)

# Luca - participant (all done, reviewed)
uts_luca = UserTripStatus.create!(
  user: user_luca,
  trip: trip6,
  role: "participant",
  trip_status: "reviewed",
  is_invited: true,
  invitation_accepted: true,
  form_filled: true,
  recommendation_reviewed: true
)

PreferencesForm.create!(
  user_trip_status: uts_luca,
  travel_pace: "moderate",
  budget: 1800,
  interests: { culture: 90, food: 90, nightlife: 40, nature: 50, shopping: 30, sport: 35 },
  activity_types: ["Museums", "Architecture", "Wine tasting"]
)

# Create recommendation with accepted: true (votes match!)
recommendation_rome = Recommendation.create!(
  trip: trip6,
  accepted: true,
  system_prompt: "Generate cultural and gastronomy activities for Rome"
)

# Create recommendation items
item_r1 = RecommendationItem.create!(
  recommendation: recommendation_rome,
  activity_item: ActivityItem.find_by(name: "Musée Rodin")
)

item_r2 = RecommendationItem.create!(
  recommendation: recommendation_rome,
  activity_item: ActivityItem.find_by(name: "Septime")
)

item_r3 = RecommendationItem.create!(
  recommendation: recommendation_rome,
  activity_item: ActivityItem.find_by(name: "Le Comptoir du Relais")
)

item_r4 = RecommendationItem.create!(
  recommendation: recommendation_rome,
  activity_item: ActivityItem.find_by(name: "Panthéon")
)

item_r5 = RecommendationItem.create!(
  recommendation: recommendation_rome,
  activity_item: ActivityItem.find_by(name: "Café de Flore")
)

# Create votes for both users (mostly likes to simulate agreement)
RecommendationVote.create!(user_trip_status: uts_sophia, recommendation_item: item_r1, like: true)
RecommendationVote.create!(user_trip_status: uts_sophia, recommendation_item: item_r2, like: true)
RecommendationVote.create!(user_trip_status: uts_sophia, recommendation_item: item_r3, like: true)
RecommendationVote.create!(user_trip_status: uts_sophia, recommendation_item: item_r4, like: true)
RecommendationVote.create!(user_trip_status: uts_sophia, recommendation_item: item_r5, like: false)

RecommendationVote.create!(user_trip_status: uts_luca, recommendation_item: item_r1, like: true)
RecommendationVote.create!(user_trip_status: uts_luca, recommendation_item: item_r2, like: true)
RecommendationVote.create!(user_trip_status: uts_luca, recommendation_item: item_r3, like: true)
RecommendationVote.create!(user_trip_status: uts_luca, recommendation_item: item_r4, like: false)
RecommendationVote.create!(user_trip_status: uts_luca, recommendation_item: item_r5, like: true)

puts "✅ Trip 6 created with #{trip6.user_trip_statuses.count} participants - Votes MATCH! (accepted: true)"

# Final summary
puts "\n" + "="*50
puts "🎯 TEST TRIPS FOR VOTE STATES"
puts "="*50
puts "\n📊 New Test Trips:"
puts "  ❌ Trip 5 (#{trip5.name}): ID #{trip5.id} - VOTES DON'T MATCH"
puts "     → All users have reviewed"
puts "     → Recommendation accepted: false"
puts "     → Should show 'Review new suggestions' button (disabled)"
puts ""
puts "  ✅ Trip 6 (#{trip6.name}): ID #{trip6.id} - VOTES MATCH!"
puts "     → All users have reviewed"
puts "     → Recommendation accepted: true"
puts "     → Should show 'Discover Itinerary' button (disabled)"
puts "="*50

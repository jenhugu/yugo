require 'open-uri'

puts "\n🖼️ Starting image attachment process...\n"

# Disable job enqueueing during image attachment
original_adapter = ActiveJob::Base.queue_adapter
ActiveJob::Base.queue_adapter = :inline

# Hash mapping activity names to Unsplash image URLs
# These are high-quality, free-to-use images from Unsplash
image_urls = {
  # Restaurants & Cafés
  "Le Comptoir du Relais" => "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800",
  "Breizh Café" => "https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800",
  "L'As du Fallafel" => "https://images.unsplash.com/photo-1529006557810-274b9b2fc783?w=800",
  "Café de Flore" => "https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800",
  "Septime" => "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800",
  "Angelina" => "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800",
  "Chez Janou" => "https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800",
  "Pink Mamma" => "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800",
  "Le Relais de l'Entrecôte" => "https://images.unsplash.com/photo-1558030006-450675393462?w=800",
  "Café Kitsuné" => "https://images.unsplash.com/photo-1511920170033-f8396924c348?w=800",
  "Bouillon Chartier" => "https://images.unsplash.com/photo-1466978913421-dad2ebd01d17?w=800",
  "Frenchie" => "https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800",
  "Holybelly" => "https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=800",
  "Le Train Bleu" => "https://images.unsplash.com/photo-1551218808-94e220e084d2?w=800",
  "Miznon" => "https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=800",
  "La Jacobine" => "https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=800",
  "Chez L'Ami Jean" => "https://images.unsplash.com/photo-1550966871-3ed3cdb5ed0c?w=800",
  "Claus" => "https://images.unsplash.com/photo-1525351484163-7529414344d8?w=800",
  "Le Baratin" => "https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800",
  "Ellsworth" => "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800",
  "Le Consulat" => "https://images.unsplash.com/photo-1509023464722-18d996393ca8?w=800",
  "Bistrot Paul Bert" => "https://images.unsplash.com/photo-1590846406792-0adc7f938f1d?w=800",
  "KB CaféShop" => "https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=800",
  "Le Chateaubriand" => "https://images.unsplash.com/photo-1600891964092-4316c288032e?w=800",
  "Carette" => "https://images.unsplash.com/photo-1587241321921-91a834d6d191?w=800",
  "Nanashi" => "https://images.unsplash.com/photo-1553621042-f6e147245754?w=800",
  "Le Servan" => "https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800",
  "Les Deux Magots" => "https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=800",
  "Chambelland" => "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800",
  "Astier" => "https://images.unsplash.com/photo-1533777857889-4be7c70b33f7?w=800",

  # Museums & Galleries
  "Musée d'Orsay" => "https://images.unsplash.com/photo-1499856871958-5b9627545d1a?w=800",
  "Musée Rodin" => "https://s2.qwant.com/thumbr/474x315/7/6/737ed878bd5bdb57059aec506f3c4099c9b80f59d9c9cb33f4d1533873d23e/OIP.JbP6EVeYUat6xFw6RKUYDgHaE7.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%2Fid%2FOIP.JbP6EVeYUat6xFw6RKUYDgHaE7%3Fcb%3Ducfimg2%26pid%3DApi%26ucfimg%3D1&q=0&b=1&p=0&a=0",
  "Centre Pompidou" => "https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3?w=800",
  "Musée de l'Orangerie" => "https://images.unsplash.com/photo-1536924940846-227afb31e2a5?w=800",
  "Musée Picasso" => "https://images.unsplash.com/photo-1561214115-f2f134cc4912?w=800",
  "Musée Jacquemart-André" => "https://images.unsplash.com/photo-1572883454114-1cf0031ede2a?w=800",
  "Atelier des Lumières" => "https://images.unsplash.com/photo-1578301978018-3005759f48f7?w=800",
  "Musée Carnavalet" => "https://images.unsplash.com/photo-1582407947304-fd86f028f716?w=800",
  "Palais de Tokyo" => "https://images.unsplash.com/photo-1571115177098-24ec42ed204d?w=800",
  "Musée Marmottan Monet" => "https://images.unsplash.com/photo-1580674285054-bed31e145f59?w=800",
  "Petit Palais" => "https://images.unsplash.com/photo-1580674285054-bed31e145f59?w=800",
  "Fondation Louis Vuitton" => "https://images.unsplash.com/photo-1565098772267-60af42b81ef2?w=800",
  "Musée des Arts Décoratifs" => "https://images.unsplash.com/photo-1518998053901-5348d3961a04?w=800",
  "Musée du Quai Branly" => "https://images.unsplash.com/photo-1564399579883-451a5d44ec08?w=800",
  "Musée Nissim de Camondo" => "https://images.unsplash.com/photo-1595246140625-573b715d11dc?w=800",
  "Musée de la Chasse et de la Nature" => "https://images.unsplash.com/photo-1554475901-4538ddfbccc2?w=800",
  "Musée Cognacq-Jay" => "https://images.unsplash.com/photo-1583585635793-0e1894c169bd?w=800",
  "Galerie Perrotin" => "https://images.unsplash.com/photo-1547826039-bfc35e0f1ea8?w=800",
  "Musée Bourdelle" => "https://s1.qwant.com/thumbr/474x316/1/e/fd20fc3d994ea6a87e4435ea26dd9395a6e62ff266bc18e19c9d8ca5ca5fbd/OIP.7ckhSjD1PVM1Orh-qVMJ4wHaE8.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%2Fid%2FOIP.7ckhSjD1PVM1Orh-qVMJ4wHaE8%3Fcb%3Ducfimg2%26pid%3DApi%26ucfimg%3D1&q=0&b=1&p=0&a=0",
  "Cité de l'Architecture" => "https://images.unsplash.com/photo-1464207687429-7505649dae38?w=800",
  "Musée Gustave Moreau" => "https://images.unsplash.com/photo-1580674285054-bed31e145f59?w=800",
  "Musée de la Vie Romantique" => "https://images.unsplash.com/photo-1583585635793-0e1894c169bd?w=800",
  "59 Rivoli" => "https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=800",
  "Institut du Monde Arabe" => "https://images.unsplash.com/photo-1564399579883-451a5d44ec08?w=800",
  "Maison de Victor Hugo" => "https://images.unsplash.com/photo-1568667256549-094345857637?w=800",

  # Monuments
  "Sainte-Chapelle" => "https://s1.qwant.com/thumbr/474x304/1/3/6073a81cfe7b312d4d7dcf814759dc26fe611c8be0dd197f3ffae95f4d0f88/OIP.1-4lq8b-7zPGUqFTHoUQXQHaEw.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%2Fid%2FOIP.1-4lq8b-7zPGUqFTHoUQXQHaEw%3Fpid%3DApi&q=0&b=1&p=0&a=0",
  "Panthéon" => "https://images.unsplash.com/photo-1568632234157-ce7aecd03d0d?w=800",
  "Arc de Triomphe" => "https://images.unsplash.com/photo-1550340499-a6c60fc8287c?w=800",
  "Conciergerie" => "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800",
  "Tour Montparnasse" => "https://images.unsplash.com/photo-1605462863863-10d9e47e15ee?w=800",
  "Basilique du Sacré-Cœur" => "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800",
  "Opéra Garnier" => "https://images.unsplash.com/photo-1516483638261-f4dbaf036963?w=800",
  "Les Invalides" => "https://s1.qwant.com/thumbr/474x294/9/8/3b70136d282bff7cac1814c6bf6360ed63da83b2ccf7f180aefdf9cd295f69/OIP.w-ANSRFCiu2QpTd9tnACQAHaEm.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%2Fid%2FOIP.w-ANSRFCiu2QpTd9tnACQAHaEm%3Fcb%3Ducfimgc2%26pid%3DApi&q=0&b=1&p=0&a=0",
  "Catacombes de Paris" => "https://images.unsplash.com/photo-1581351721010-8cf859cb14a4?w=800",
  "Notre-Dame de Paris" => "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800",
  "Château de Vincennes" => "https://s2.qwant.com/thumbr/474x315/6/2/b2e0962b01d111152fa26058e95d8fe06f90d2bdae76c8768543ab604c9c38/OIP.bCIg1UDrgiwoZr7BKfA6GwHaE7.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%2Fid%2FOIP.bCIg1UDrgiwoZr7BKfA6GwHaE7%3Fcb%3Ducfimgc2%26pid%3DApi&q=0&b=1&p=0&a=0",
  "Tour Eiffel" => "https://images.unsplash.com/photo-1511739001486-6bfe10ce785f?w=800",
  "Arènes de Lutèce" => "https://s2.qwant.com/thumbr/474x266/e/2/3ebfbd5cc7f589e52926275a283c32689d59a5b8b333b4ea19f6fe7b094a78/OIP.bqzbv4sdxk7d037mhz1p_wHaEK.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%2Fid%2FOIP.bqzbv4sdxk7d037mhz1p_wHaEK%3Fcb%3Ducfimg2%26pid%3DApi%26ucfimg%3D1&q=0&b=1&p=0&a=0",
  "Palais Royal" => "https://s2.qwant.com/thumbr/474x315/4/f/f3d0a78018f3fdabee3af829d21b298e3e1b5fbf8d544c7282853e7b7d7223/OIP.VJsOiYntL1ZrPOSXpww3AwAAAA.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%2Fid%2FOIP.VJsOiYntL1ZrPOSXpww3AwAAAA%3Fcb%3Ducfimg2%26pid%3DApi%26ucfimg%3D1&q=0&b=1&p=0&a=0",
  "Église Saint-Sulpice" => "https://s1.qwant.com/thumbr/474x259/a/5/df1ca77f0834a9dca97662778992e04e320450f721da2c6550b6817e898c5f/OIP.VRJoBW9he3Pc6oqjPTXjkwHaED.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%2Fid%2FOIP.VRJoBW9he3Pc6oqjPTXjkwHaED%3Fcb%3Ducfimg2%26pid%3DApi%26ucfimg%3D1&q=0&b=1&p=0&a=0",
  "Église Saint-Eustache" => "https://s1.qwant.com/thumbr/474x316/1/f/37bc27f2732895264b7d45b52ee5550083decce83f0dae714dfda233d26101/OIP.yu7PSmH0sHtqa4J-aBaABwHaE8.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%2Fid%2FOIP.yu7PSmH0sHtqa4J-aBaABwHaE8%3Fcb%3Ducfimg2%26pid%3DApi%26ucfimg%3D1&q=0&b=1&p=0&a=0",
  "Pont Alexandre III" => "https://s2.qwant.com/thumbr/474x317/5/5/b46502c53a6a5be7477525ca37768513777759c5f66ead1f504b8b2b4bde10/OIP.m144AcOO0Wdqdcee5CbT_AHaE9.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%2Fid%2FOIP.m144AcOO0Wdqdcee5CbT_AHaE9%3Fcb%3Ducfimg2%26pid%3DApi%26ucfimg%3D1&q=0&b=1&p=0&a=0",
  "Crypte Archéologique" => "https://images.unsplash.com/photo-1581351721010-8cf859cb14a4?w=800",
  "Pavillon de l'Arsenal" => "https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800",
  "La Coulée Verte" => "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",

  # Events
  "Concert à la Philharmonie" => "https://images.unsplash.com/photo-1465847899084-d164df4dedc6?w=800",
  "Soirée au Crazy Horse" => "https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=800",
  "Cinéma Le Grand Rex" => "https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=800",
  "Moulin Rouge" => "https://images.unsplash.com/photo-1576085898323-218337e3e43c?w=800",
  "Jazz au Duc des Lombards" => "https://images.unsplash.com/photo-1511192336575-5a79af67a629?w=800",
  "Comédie-Française" => "https://images.unsplash.com/photo-1503095396549-807759245b35?w=800",
  "New Morning" => "https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=800",
  "Cinéma La Pagode" => "https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=800",
  "Théâtre de l'Odéon" => "https://images.unsplash.com/photo-1507924538820-ede94a04019d?w=800",
  "L'Olympia" => "https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?w=800",
  "Point Éphémère" => "https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=800",
  "Opéra Bastille" => "https://images.unsplash.com/photo-1580809361436-42a7ec204889?w=800",
  "Café de la Danse" => "https://images.unsplash.com/photo-1429962714451-bb934ecdc4ec?w=800",
  "Shakespeare and Company Readings" => "https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=800",
  "Parc de la Villette - Cinéma en plein air" => "https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=800",

  # Sports & Leisure
  "Croisière sur la Seine" => "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800",
  "Ballon de Paris" => "https://images.unsplash.com/photo-1473496169904-658ba7c44d8a?w=800",
  "Vélo le long du Canal Saint-Martin" => "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=800",
  "Piscine Joséphine Baker" => "https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?w=800",
  "Jardin du Luxembourg" => "https://images.unsplash.com/photo-1566404791232-af9fe0ae8f8b?w=800",
  "Parc des Buttes-Chaumont" => "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
  "Roller à Rollers & Coquillages" => "https://images.unsplash.com/photo-1542779283-429940ce8336?w=800",
  "MurMur Escalade Pantin" => "https://images.unsplash.com/photo-1522163182402-834f871fd851?w=800",
  "Bois de Vincennes" => "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
  "Berges de Seine" => "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800"
}

success_count = 0
error_count = 0

image_urls.each do |activity_name, url|
  activity = ActivityItem.find_by(name: activity_name)

  if activity.nil?
    puts "⚠️  Activity '#{activity_name}' not found - skipping"
    error_count += 1
    next
  end

  begin
    # Download the image from Unsplash
    downloaded_image = URI.open(url)

    # Attach it to the activity item
    activity.image.attach(
      io: downloaded_image,
      filename: "#{activity_name.parameterize}.jpg",
      content_type: 'image/jpeg'
    )

    puts "✅ Image attached to '#{activity_name}'"
    success_count += 1
  rescue => e
    puts "❌ Error attaching image to '#{activity_name}': #{e.message}"
    error_count += 1
  end
end

puts "\n📊 Image attachment complete!"
puts "✅ Success: #{success_count}"
puts "❌ Errors: #{error_count}"
puts "\n🎉 All done!\n"

# Restore original job adapter
ActiveJob::Base.queue_adapter = original_adapter

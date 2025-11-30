require 'open-uri'

puts "\n🖼️ Starting image attachment process...\n"

# Disable job enqueueing during image attachment
original_adapter = ActiveJob::Base.queue_adapter
ActiveJob::Base.queue_adapter = :inline

# Hash mapping activity names to Unsplash image URLs
# These are high-quality, free-to-use images from Unsplash
image_urls = {
  # Restaurants & Cafés
  "Le Comptoir du Relais" => "https://axwwgrkdco.cloudimg.io/v7/__gmpics3__/7151bd05c3694b18beb985e7fc9695f3.jpg?w=49&org_if_sml=1",
  "Breizh Café" => "https://passion-aquitaine.ouest-france.fr/wp-content/uploads/2022/10/breizh-cafe-bordeaux.jpg.webp",
  "L'As du Fallafel" => "https://2cupsoftravel.com/wp-content/uploads/2022/05/las-du-fallafel-paris-e1651641294965-1200x900.jpg",
  "Café de Flore" => "https://assets.vogue.com/photos/6696fb1032fc604778daa71a/master/w_2240,c_limit/1842695813",
  "Septime" => "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800",
  "Angelina" => "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800",
  "Chez Janou" => "https://offloadmedia.feverup.com/parissecret.com/wp-content/uploads/2025/07/29233627/9-3.jpg",
  "Pink Mamma" => "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800",
  "Le Relais de l'Entrecôte" => "https://images.unsplash.com/photo-1558030006-450675393462?w=800",
  "Café Kitsuné" => "https://images.unsplash.com/photo-1511920170033-f8396924c348?w=800",
  "Bouillon Chartier" => "https://paris-frivole.com/wp-content/uploads/2022/01/Bouillon-Chartier-Grands-Boulevards-int-scaled.jpg",
  "Frenchie" => "https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800",
  "Holybelly" => "https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=800",
  "Le Train Bleu" => "https://images.unsplash.com/photo-1551218808-94e220e084d2?w=800",
  "Miznon" => "https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=800",
  "La Jacobine" => "https://www.restoaparis.com/cdn-cgi/image/width=1500,height=1000,quality=65,format=webp/photos-vip/restaurant-la-jacobine-paris-6-salle/$file/restaurant-la-jacobine-paris-6-salle.jpg",
  "Chez L'Ami Jean" => "https://images.unsplash.com/photo-1550966871-3ed3cdb5ed0c?w=800",
  "Claus" => "https://images.unsplash.com/photo-1525351484163-7529414344d8?w=800",
  "Le Baratin" => "https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800",
  "Ellsworth" => "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800",
  "Le Consulat" => "https://www.girlwiththepassport.com/wp-content/uploads/2019/08/Le-Consulat.jpg.webp",
  "Bistrot Paul Bert" => "https://images.unsplash.com/photo-1590846406792-0adc7f938f1d?w=800",
  "KB CaféShop" => "https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=800",
  "Le Chateaubriand" => "https://images.unsplash.com/photo-1600891964092-4316c288032e?w=800",
  "Carette" => "https://images.unsplash.com/photo-1587241321921-91a834d6d191?w=800",
  "Nanashi" => "https://images.unsplash.com/photo-1553621042-f6e147245754?w=800",
  "Le Servan" => "https://media.cntraveler.com/photos/5a821185a2fdaf4c74bb5f6d/16:9/w_2240,c_limit/Le-Servan_Edouard-Sepulchre_2018_LA_SALLE_4.jpg",
  "Les Deux Magots" => "https://cdn.sortiraparis.com/images/1001/102070/884894-les-deux-magots-gouter-terrasse-a7c0844.jpg",
  "Chambelland" => "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800",
  "Astier" => "https://images.unsplash.com/photo-1533777857889-4be7c70b33f7?w=800",

  # Museums & Galleries
  "Musée d'Orsay" => "https://media.timeout.com/images/105976901/1920/1080/image.webp",
  "Musée Rodin" => "https://s2.qwant.com/thumbr/474x315/7/6/737ed878bd5bdb57059aec506f3c4099c9b80f59d9c9cb33f4d1533873d23e/OIP.JbP6EVeYUat6xFw6RKUYDgHaE7.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%2Fid%2FOIP.JbP6EVeYUat6xFw6RKUYDgHaE7%3Fcb%3Ducfimg2%26pid%3DApi%26ucfimg%3D1&q=0&b=1&p=0&a=0",
  "Centre Pompidou" => "https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3?w=800",
  "Musée de l'Orangerie" => "https://images.unsplash.com/photo-1536924940846-227afb31e2a5?w=800",
  "Musée Picasso" => "https://images.unsplash.com/photo-1561214115-f2f134cc4912?w=800",
  "Musée Jacquemart-André" => "https://images.unsplash.com/photo-1572883454114-1cf0031ede2a?w=800",
  "Atelier des Lumières" => "https://images.unsplash.com/photo-1578301978018-3005759f48f7?w=800",
  "Musée Carnavalet" => "https://cdn.paris.fr/eqpts-prod/2022/05/31/d81e190b496a4e504883333dacd7287d.jpeg",
  "Palais de Tokyo" => "https://pro.visitparisregion.com/var/crt_idf/storage/images/_aliases/xlarge/6/1/9/7/1107916-2-fre-FR/d10ace771933-PALAIS-DE-TOKYO.jpg",
  "Musée Marmottan Monet" => "https://www.parisunlocked.com/wp-content/uploads/2021/10/IMG_0997-1024x768.jpg",
  "Petit Palais" => "https://loving-travel.com/wp-content/uploads/2022/09/220926100443001-e1664180579295.jpg",
  "Fondation Louis Vuitton" => "https://images.unsplash.com/photo-1565098772267-60af42b81ef2?w=800",
  "Musée des Arts Décoratifs" => "https://images.unsplash.com/photo-1518998053901-5348d3961a04?w=800",
  "Musée du Quai Branly" => "https://images.unsplash.com/photo-1564399579883-451a5d44ec08?w=800",
  "Musée Nissim de Camondo" => "https://images.unsplash.com/photo-1595246140625-573b715d11dc?w=800",
  "Musée de la Chasse et de la Nature" => "https://images.unsplash.com/photo-1554475901-4538ddfbccc2?w=800",
  "Musée Cognacq-Jay" => "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh8BsiHcFP1-zEh4i-1r1mRzn7uOix_7wJ3sHOAUUuklWX45GkqJzdvOyGAvIUO_LOqHSfxoI7e82_EL4SXOQBXcrzXUmAVElQpOaeTAbW7_BHAAOpOnbTxQ30HzT0GW2B6WzQltrKlGVWR/s640/Le+mus%25C3%25A9e+Cognacq+Jay+Paris+%25289%2529.JPG",
  "Galerie Perrotin" => "https://images.unsplash.com/photo-1547826039-bfc35e0f1ea8?w=800",
  "Musée Bourdelle" => "https://s1.qwant.com/thumbr/474x316/1/e/fd20fc3d994ea6a87e4435ea26dd9395a6e62ff266bc18e19c9d8ca5ca5fbd/OIP.7ckhSjD1PVM1Orh-qVMJ4wHaE8.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%2Fid%2FOIP.7ckhSjD1PVM1Orh-qVMJ4wHaE8%3Fcb%3Ducfimg2%26pid%3DApi%26ucfimg%3D1&q=0&b=1&p=0&a=0",
  "Cité de l'Architecture" => "https://i-de.unimedias.fr/2023/12/07/dethsvisites12architectureentreefranckcharel-6571e6c94109a.jpg?auto=format%2Ccompress&crop=faces&cs=tinysrgb&fit=max&ixlib=php-4.1.0&w=1050",
  "Musée Gustave Moreau" => "https://cdn.sortiraparis.com/images/1001/101599/865760-musee-gustave-moreau-img-0813.jpg",
  "Musée de la Vie Romantique" => "https://s1.qwant.com/thumbr/474x237/9/1/172cbfda974148087abad804ea11aac16fd9c202f3d53d97e57f99b9cdb328/OIP.t2LufViPpLHTgE9UkSHSZQHaDt.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%2Fid%2FOIP.t2LufViPpLHTgE9UkSHSZQHaDt%3Fpid%3DApi&q=0&b=1&p=0&a=0",
  "59 Rivoli" => "https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=800",
  "Institut du Monde Arabe" => "https://images.unsplash.com/photo-1564399579883-451a5d44ec08?w=800",
  "Maison de Victor Hugo" => "https://cdn.sortiraparis.com/images/1001/94223/652567-la-maison-de-victor-hugo-a-paris-nos-photos.jpg",

  # Monuments
  "Sainte-Chapelle" => "https://s1.qwant.com/thumbr/474x304/1/3/6073a81cfe7b312d4d7dcf814759dc26fe611c8be0dd197f3ffae95f4d0f88/OIP.1-4lq8b-7zPGUqFTHoUQXQHaEw.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%2Fid%2FOIP.1-4lq8b-7zPGUqFTHoUQXQHaEw%3Fpid%3DApi&q=0&b=1&p=0&a=0",
  "Panthéon" => "https://frenchmoments.eu/wp-content/uploads/2013/06/Panth%C3%A9on-Paris-%C2%A9-French-Moments.jpg",
  "Arc de Triomphe" => "https://www.tripsavvy.com/thmb/NqkwY1hBM-3hteZWbWWtt_8xGnM=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/Untitled_Panorama44-c858c1d4792c493aba97dba8a0893645.jpg",
  "Conciergerie" => "https://cdn.sortiraparis.com/images/61/101888/878236-paris-capitale-de-la-gastronomie-l-exposition-qui-nous-donne-faim-a-la-conciergerie-photos-img20230412102912.jpg",
  "Tour Montparnasse" => "https://images.unsplash.com/photo-1605462863863-10d9e47e15ee?w=800",
  "Basilique du Sacré-Cœur" => "https://paristouristinformation.fr/wp-content/uploads/2021/01/A-Guide-to-Sacre-Coeur-Basilica-in-Paris-in-France.jpg",
  "Opéra Garnier" => "https://images.unsplash.com/photo-1516483638261-f4dbaf036963?w=800",
  "Les Invalides" => "https://s1.qwant.com/thumbr/474x294/9/8/3b70136d282bff7cac1814c6bf6360ed63da83b2ccf7f180aefdf9cd295f69/OIP.w-ANSRFCiu2QpTd9tnACQAHaEm.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%2Fid%2FOIP.w-ANSRFCiu2QpTd9tnACQAHaEm%3Fcb%3Ducfimgc2%26pid%3DApi&q=0&b=1&p=0&a=0",
  "Catacombes de Paris" => "https://www.outgomag.com/wp-content/uploads/2022/11/passage-catacombe-paris.jpg.webp",
  "Notre-Dame de Paris" => "https://berqwp-cdn.sfo3.cdn.digitaloceanspaces.com/cache/www.tout-paris.org/wp-content/uploads/2019/01/tour-Notre-Dame-de-Paris-839w-2x-jpg.webp?bwp",
  "Château de Vincennes" => "https://s2.qwant.com/thumbr/474x315/6/2/b2e0962b01d111152fa26058e95d8fe06f90d2bdae76c8768543ab604c9c38/OIP.bCIg1UDrgiwoZr7BKfA6GwHaE7.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%2Fid%2FOIP.bCIg1UDrgiwoZr7BKfA6GwHaE7%3Fcb%3Ducfimgc2%26pid%3DApi&q=0&b=1&p=0&a=0",
  "Tour Eiffel" => "https://images.unsplash.com/photo-1511739001486-6bfe10ce785f?w=800",
  "Arènes de Lutèce" => "https://media.timeout.com/images/105956515/1920/1080/image.webp",
  "Palais Royal" => "https://s2.qwant.com/thumbr/474x315/4/f/f3d0a78018f3fdabee3af829d21b298e3e1b5fbf8d544c7282853e7b7d7223/OIP.VJsOiYntL1ZrPOSXpww3AwAAAA.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%2Fid%2FOIP.VJsOiYntL1ZrPOSXpww3AwAAAA%3Fcb%3Ducfimg2%26pid%3DApi%26ucfimg%3D1&q=0&b=1&p=0&a=0",
  "Église Saint-Sulpice" => "https://s1.qwant.com/thumbr/474x259/a/5/df1ca77f0834a9dca97662778992e04e320450f721da2c6550b6817e898c5f/OIP.VRJoBW9he3Pc6oqjPTXjkwHaED.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%2Fid%2FOIP.VRJoBW9he3Pc6oqjPTXjkwHaED%3Fcb%3Ducfimg2%26pid%3DApi%26ucfimg%3D1&q=0&b=1&p=0&a=0",
  "Église Saint-Eustache" => "https://s1.qwant.com/thumbr/474x316/1/f/37bc27f2732895264b7d45b52ee5550083decce83f0dae714dfda233d26101/OIP.yu7PSmH0sHtqa4J-aBaABwHaE8.jpg?u=https%3A%2F%2Ftse.mm.bing.net%2Fth%2Fid%2FOIP.yu7PSmH0sHtqa4J-aBaABwHaE8%3Fcb%3Ducfimg2%26pid%3DApi%26ucfimg%3D1&q=0&b=1&p=0&a=0",
  "Pont Alexandre III" => "https://www.cestujlevne.com/obrazky/32/27/73227-1840w.webp",
  "Crypte Archéologique" => "https://www.cometoparis.com/data/layout_grouping/product_index_slideshow/50497_crypte-archeologique-de-l-ile-de-la-cite-entree.1000w.jpg?ver=1675417789",
  "Pavillon de l'Arsenal" => "https://www.pavillon-arsenal.com/data/le-pavillon-de-larsenal_64d57/fiche/9972/colonne_sans_titre-4_0003_colonne_ars_image_ext_frontale_projet_08d7c_52c96.jpg",
  "La Coulée Verte" => "https://cdn.sortiraparis.com/images/1001/98634/768330-la-coulee-verte-la-promenade-insolite-de-la-bastille-a-vincennes.jpg",

  # Events
  "Concert à la Philharmonie" => "https://images.unsplash.com/photo-1465847899084-d164df4dedc6?w=800",
  "Cinéma Le Grand Rex" => "https://cdn.sortiraparis.com/images/1001/109289/1146619-salle-love-grand-rex-image00044.jpg",
  "Moulin Rouge" => "https://cdn.sortiraparis.com/images/1001/1467/1093420-le-moulin-rouge-retrouve-ses-ailes-french-cancan-et-son-et-lumiere-au-programme-de-l-inauguration.jpg",
  "Jazz au Duc des Lombards" => "https://images.unsplash.com/photo-1511192336575-5a79af67a629?w=800",
  "Comédie-Française" => "https://images.unsplash.com/photo-1503095396549-807759245b35?w=800",
  "New Morning" => "https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=800",
  "Cinéma La Pagode" => "https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=800",
  "Théâtre de l'Odéon" => "https://images.unsplash.com/photo-1507924538820-ede94a04019d?w=800",
  "L'Olympia" => "https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?w=800",
  "Point Éphémère" => "https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=800",
  "Opéra Bastille" => "https://images.unsplash.com/photo-1580809361436-42a7ec204889?w=800",
  "Café de la Danse" => "https://www.urbansider.com/wp-content/uploads/2019/10/cafe-de-la-danse-entrance.jpg",
  "Shakespeare and Company Readings" => "https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=800",
  "Parc de la Villette - Cinéma en plein air" => "https://media.timeout.com/images/100004909/1920/1440/image.webp",

  # Sports & Leisure
  "Croisière sur la Seine" => "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800",
  "Ballon de Paris" => "https://www.cometoparis.com/data/layout_grouping/product_index_slideshow/61076_ballon-generali.1000w.jpg?ver=1684334713",
  "Vélo le long du Canal Saint-Martin" => "https://www.wegwijsnaarparijs.nl/wp-content/uploads/2018/05/canal_saint_martin_parijs_foto.jpg",
  "Piscine Joséphine Baker" => "https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?w=800",
  "Jardin du Luxembourg" => "https://cdn.sortiraparis.com/images/1001/62403/349310-le-jardin-du-luxembourg-a-paris-un-chef-d-oeuvre-botanique.jpg",
  "Parc des Buttes-Chaumont" => "https://cdn.sanity.io/images/nxpteyfv/goguides/e06bd5b59d1d168c5c38604a929b858171ae3de7-1600x1066.jpg?fp-x=0.5&fp-y=0.5&w=1351&fit=max&auto=format",
  "Roller à Rollers & Coquillages" => "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/08/4b/6c/6c/rollers-coquillages.jpg?w=2000&h=-1&s=1",
  "MurMur Escalade Pantin" => "https://images.unsplash.com/photo-1522163182402-834f871fd851?w=800",
  "Bois de Vincennes" => "https://media.timeout.com/images/105486907/1920/1080/image.webp",
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

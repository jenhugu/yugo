class Recommendation < ApplicationRecord
  belongs_to :trip
  has_many :recommendation_items, dependent: :destroy
  has_many :activity_items, through: :recommendation_items
  has_many :recommendation_votes, through: :recommendation_items

  # Vérifie si tous les utilisateurs ont reviewé les recommandations
  def all_users_reviewed?
    trip.user_trip_statuses.all? { |status| status.recommendation_reviewed == true }
  end

  # Retourne les recommendation_items avec majorité de likes
  def approved_items
    total_users = trip.user_trip_statuses.count

    recommendation_items.includes(:recommendation_votes).select do |item|
      likes_count = item.recommendation_votes.where(like: true).count
      likes_count > (total_users / 2.0)
    end
  end

  # Calcule si la recommendation doit être acceptée basée sur les votes
  def calculate_acceptance!
    return unless all_users_reviewed?

    total_items = recommendation_items.count

    # Utiliser approved_items au lieu de recalculer
    items_with_majority_likes = approved_items.count

    # Majorité des items doivent avoir majorité de likes (> 50%)
    items_majority = items_with_majority_likes > (total_items / 2.0)

    # Mise à jour du champ accepted
    update(accepted: items_majority)
  end

  # Vérifie si tous les users ont reviewé, calcule l'acceptance et génère l'itinéraire si accepté
  def verify_and_generate_itinerary!
    return false unless all_users_reviewed?

    calculate_acceptance!

    if accepted
      GenerateItineraryJob.perform_later(id)
      true
    else
      # Recommendation rejetée : générer une nouvelle avec les préférences mises à jour
      trip.generate_new_recommendation_after_rejection!
    end
  end
end

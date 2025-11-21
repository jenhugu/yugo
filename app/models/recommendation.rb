class Recommendation < ApplicationRecord
  belongs_to :trip
  has_many :recommendation_items, dependent: :destroy
  has_many :activity_items, through: :recommendation_items
  has_many :recommendation_votes, through: :recommendation_items

  # Vérifie si tous les utilisateurs ont reviewé les recommandations
  def all_users_reviewed?
    trip.user_trip_statuses.all? { |status| status.recommendation_reviewed == true }
  end

  # Calcule si la recommendation doit être acceptée basée sur les votes
  def calculate_acceptance!
    return unless all_users_reviewed?

    total_items = recommendation_items.count
    total_users = trip.user_trip_statuses.count

    # Compter les items avec majorité de likes
    items_with_majority_likes = recommendation_items.count do |item|
      votes_on_item = recommendation_votes.where(recommendation_item: item)
      likes_count = votes_on_item.where(like: true).count
      likes_count > (total_users / 2.0)
    end

    # Majorité des items doivent avoir majorité de likes (> 50%)
    items_majority = items_with_majority_likes > (total_items / 2.0)

    # Mise à jour du champ accepted
    update(accepted: items_majority)
  end
end

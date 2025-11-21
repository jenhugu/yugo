class RemoveLikeFromRecommendationItems < ActiveRecord::Migration[7.1]
  def change
    remove_column :recommendation_items, :like, :boolean
  end
end

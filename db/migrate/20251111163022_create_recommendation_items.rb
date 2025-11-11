class CreateRecommendationItems < ActiveRecord::Migration[7.1]
  def change
    create_table :recommendation_items do |t|
      t.boolean :like

      t.timestamps
    end
  end
end

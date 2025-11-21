class CreateRecommendationVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :recommendation_votes do |t|
      t.references :user_trip_status, null: false, foreign_key: true
      t.references :recommendation_item, null: false, foreign_key: true
      t.boolean :like

      t.timestamps
    end

    add_index :recommendation_votes, [:user_trip_status_id, :recommendation_item_id], unique: true, name: 'index_recommendation_votes_on_user_and_item'
  end
end

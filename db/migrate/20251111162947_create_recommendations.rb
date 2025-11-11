class CreateRecommendations < ActiveRecord::Migration[7.1]
  def change
    create_table :recommendations do |t|
      t.boolean :accepted
      t.string :system_prompt

      t.timestamps
    end
  end
end

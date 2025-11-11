class CreateActivityItems < ActiveRecord::Migration[7.1]
  def change
    create_table :activity_items do |t|
      t.string :name
      t.string :description
      t.integer :price
      t.string :reservation_url
      t.string :type

      t.timestamps
    end
  end
end

class CreateItineraryItems < ActiveRecord::Migration[7.1]
  def change
    create_table :itinerary_items do |t|
      t.string :date
      t.string :slot
      t.string :time
      t.string :position

      t.timestamps
    end
  end
end

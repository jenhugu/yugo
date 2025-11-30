class AddCoordinatesToActivityItems < ActiveRecord::Migration[7.1]
  def change
    add_column :activity_items, :latitude, :float
    add_column :activity_items, :longitude, :float
  end
end

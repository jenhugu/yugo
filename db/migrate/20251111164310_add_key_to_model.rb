class AddKeyToModel < ActiveRecord::Migration[7.1]
  def change
    add_reference :preferences_forms, :trips, null: false, foreign_key: true
  end
end

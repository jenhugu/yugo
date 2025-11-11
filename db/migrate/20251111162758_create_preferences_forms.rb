class CreatePreferencesForms < ActiveRecord::Migration[7.1]
  def change
    create_table :preferences_forms do |t|
      t.string :travel_pace
      t.integer :budget
      t.string :interests
      t.string :activity_types

      t.timestamps
    end
  end
end

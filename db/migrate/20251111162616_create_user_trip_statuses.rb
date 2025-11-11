class CreateUserTripStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :user_trip_statuses do |t|
      t.binary :role
      t.string :trip_status
      t.boolean :is_invited
      t.boolean :form_filled
      t.boolean :recommendation_reviewed
      t.boolean :invitation_accepted

      t.timestamps
    end
  end
end

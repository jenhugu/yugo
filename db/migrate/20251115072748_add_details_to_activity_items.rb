class AddDetailsToActivityItems < ActiveRecord::Migration[7.1]
  def change
    add_column :activity_items, :address, :text
    add_column :activity_items, :city, :string
    add_column :activity_items, :country, :string
    add_column :activity_items, :opening_hours, :text
    add_column :activity_items, :duration, :integer
    add_column :activity_items, :tagline, :string
  end
end

class RenameTypeToActivityTypeInActivityItems < ActiveRecord::Migration[7.1]
  def change
    rename_column :activity_items, :type, :activity_type
  end
end

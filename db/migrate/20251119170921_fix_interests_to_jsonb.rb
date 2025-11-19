class FixInterestsToJsonb < ActiveRecord::Migration[7.0]
  def up
    # 1. Add the new JSONB column
    add_column :preferences_forms, :interests_json, :jsonb, default: {}

    # Load schema
    PreferencesForm.reset_column_information

    # 2. Copy only valid Ruby-hash-like strings into the new JSONB column
    PreferencesForm.find_each do |pf|
      raw = pf.read_attribute(:interests)

      cleaned =
        if raw.is_a?(Hash)
          # Already correct
          raw.transform_keys(&:to_s)

        elsif raw.is_a?(String) && raw.strip.start_with?("{") && raw.include?("=>")
          begin
            # Try converting Ruby hash string safely WITHOUT using eval
            ruby_hash = raw
                          .gsub(/:(\w+)=>/, '"\1":')  # convert :keys => to "keys":
                          .gsub("=>", ":")            # convert remaining => to :
            parsed = JSON.parse(ruby_hash) rescue {}
            parsed.is_a?(Hash) ? parsed : {}
          rescue
            {}
          end

        else
          # Completely invalid, ignore
          {}
        end

      pf.update_columns(interests_json: cleaned)
    end

    # 3. Remove the old column
    remove_column :preferences_forms, :interests

    # 4. Rename to the new one
    rename_column :preferences_forms, :interests_json, :interests
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

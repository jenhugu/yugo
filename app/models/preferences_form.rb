class PreferencesForm < ApplicationRecord
  belongs_to :user_trip_status

  # ----------------------------------------
  # ACTIVITY TYPES (Array)
  # ----------------------------------------
  def activity_types
    value = super

    return value if value.is_a?(Array)
    return value.split(",").map(&:strip) if value.is_a?(String)

    []
  end

  def activity_types=(value)
    if value.is_a?(String)
      super(value.split(",").map(&:strip))
    else
      super(value)
    end
  end

  # ----------------------------------------
  # INTERESTS (Hash, from sliders)
  # e.g. { culture: 80, food: 60, sport: 30 }
  # ----------------------------------------
  def interests
    value = super

    return value if value.is_a?(Hash)
    return JSON.parse(value) if value.is_a?(String) rescue {}

    {}
  end

  def interests=(value)
    # Normalize:
    # - permit Hash
    # - convert string keys to symbols
    # - parse JSON strings
    if value.is_a?(String)
      begin
        parsed = JSON.parse(value)
        super(parsed.transform_keys(&:to_sym))
      rescue
        super({})
      end
    elsif value.is_a?(Hash)
      super(value.transform_keys(&:to_sym))
    else
      super({})
    end
  end
end

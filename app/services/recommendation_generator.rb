class RecommendationGenerator
  def initialize(trip)
    @trip = trip
  end

  def call
    # 1. Construire le prompt
    prompt = build_prompt

    # 2. Appeler le LLM
    activity_ids = ask_llm(prompt)

    # 3. Créer les recommendations en DB
    create_recommendations(activity_ids)
  end

  private

  def aggregate_preferences
    participants_data = []

    @trip.user_trip_statuses.each_with_index do |user_trip_status, index|
      preferences_form = user_trip_status.preferences_form

      # Formatter les intérêts avec leurs scores
      interests_str = if preferences_form.interests.present?
                        preferences_form.interests.map { |key, value| "#{key}: #{value}/100" }.join(", ")
                      else
                        "None specified"
                      end

      # Formatter les activity_types
      activity_types_str = preferences_form.activity_types.present? ?
        preferences_form.activity_types.join(", ") :
        "No preferences"

      participants_data << <<~PARTICIPANT
        Participant #{index + 1}:
        - Budget: #{preferences_form.budget}€ per activity
        - Travel pace: #{preferences_form.travel_pace}
        - Steps per day: #{preferences_form.steps_per_day || 'Not specified'} steps
        - Interests: #{interests_str}
        - Activity types: #{activity_types_str}
      PARTICIPANT
    end

    participants_data.join("\n")
  end

  def build_prompt
      # Récupérer toutes les activités disponibles
      activities = ActivityItem.all.map do |activity|
        "ID: #{activity.id} | #{activity.name} | Type: #{activity.activity_type} | Price: #{activity.price}€ | #{activity.tagline}"
      end.join("\n")

      # Récupérer les préférences de tous les participants
      preferences = aggregate_preferences

      <<~PROMPT
        You are a travel recommendation expert for Paris.

        TRIP INFORMATION:
        - Destination: #{@trip.destination}
        - Dates: #{@trip.start_date} to #{@trip.end_date}
        - Trip type: #{@trip.trip_type}

        GROUP PREFERENCES:
        #{preferences}

        AVAILABLE ACTIVITIES:
        #{activities}

        TASK:
        Analyze the group preferences and recommend exactly 10 activities from the list above that best match their interests, budget, and travel pace.

        IMPORTANT:
        - Return ONLY a JSON array of activity IDs (integers)
        - Format: [1, 5, 12, 23, 34, 45, 56, 67, 78, 89]
        - No explanations, no additional text, just the JSON array
        - Choose activities that balance everyone's preferences
        - Each activity ID must be UNIQUE (no duplicates allowed)
        - Select 10 DIFFERENT activities
      PROMPT
  end

  def ask_llm(prompt)
    # Appeler le LLM avec le prompt
    chat = RubyLLM.chat(model: "gpt-4o")
    response = chat.ask(prompt)

    # Parser la réponse JSON
    activity_ids = JSON.parse(response.content)

    # Vérifier que ce sont bien des IDs valides
    activity_ids.select { |id| ActivityItem.exists?(id) }
  rescue JSON::ParserError => e
    Rails.logger.error "Failed to parse LLM response: #{e.message}"
    Rails.logger.error "Response was: #{response.content}"
    []
  rescue => e
    Rails.logger.error "Failed to call LLM: #{e.message}"
    []
  end

  def create_recommendations(activity_ids)
    return nil if activity_ids.empty?

    # Dédupliquer les activity_ids pour éviter les doublons
    unique_activity_ids = activity_ids.uniq

    # Logger si des doublons ont été détectés
    if unique_activity_ids.count < activity_ids.count
      Rails.logger.warn "Removed #{activity_ids.count - unique_activity_ids.count} duplicate activity IDs from LLM response"
    end

    # Créer l'objet Recommendation
    recommendation = Recommendation.create!(
      trip: @trip,
      accepted: nil,
      system_prompt: "Generated recommendations based on group preferences"
    )

    # Créer un RecommendationItem pour chaque activité unique
    unique_activity_ids.each do |activity_id|
      RecommendationItem.create!(
        recommendation: recommendation,
        activity_item_id: activity_id
      )
    end

    Rails.logger.info "Created #{unique_activity_ids.count} recommendations for trip #{@trip.id}"
    recommendation
  end
end

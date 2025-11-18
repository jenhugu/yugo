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

  def mock_preferences
    <<~PREFS
      Participant 1:
      - Budget: 50€ per activity
      - Travel pace: relaxed
      - Interests: art, food, history
      - Activity types: museum, restaurant, cultural

      Participant 2:
      - Budget: 40€ per activity
      - Travel pace: moderate
      - Interests: food, nightlife
      - Activity types: restaurant, bar, concert
    PREFS
  end

  def build_prompt
      # Récupérer toutes les activités disponibles
      activities = ActivityItem.all.map do |activity|
        "ID: #{activity.id} | #{activity.name} | Type: #{activity.activity_type} | Price: #{activity.price}€ | #{activity.tagline}"
      end.join("\n")

      # Préférences mockées (en attendant le vrai formulaire)
      preferences = mock_preferences

      <<~PROMPT
        You are a travel recommendation expert for Paris.

        TRIP INFORMATION:
        - Destination: #{@trip.destination}
        - Dates: #{@trip.date}
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

    # Créer l'objet Recommendation
    recommendation = Recommendation.create!(
      trip: @trip,
      accepted: nil,
      system_prompt: "Generated recommendations based on group preferences"
    )

    # Créer un RecommendationItem pour chaque activité
    activity_ids.each do |activity_id|
      RecommendationItem.create!(
        recommendation: recommendation,
        activity_item_id: activity_id,
        like: nil  # Pas encore reviewé
      )
    end

    Rails.logger.info "Created #{activity_ids.count} recommendations for trip #{@trip.id}"
    recommendation
  end
end

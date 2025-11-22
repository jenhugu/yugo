class ItineraryGenerator
  def initialize(recommendation)
    @recommendation = recommendation
    @trip = recommendation.trip
  end

  def call
    # 1. Récupérer les activités approuvées (majorité de likes)
    approved_activities = @recommendation.approved_items.map(&:activity_item)

    return nil if approved_activities.empty?

    # 2. Construire le prompt pour organiser l'itinéraire
    prompt = build_itinerary_prompt(approved_activities)

    # 3. Appeler le LLM
    itinerary_schedule = ask_llm(prompt)

    # 4. Créer l'itinéraire en DB
    create_itinerary(itinerary_schedule) if itinerary_schedule.present?
  end

  private

  def build_itinerary_prompt(activities)
    # Formatter les activités avec toutes leurs infos
    activities_str = activities.map do |activity|
      <<~ACTIVITY.strip
        ID: #{activity.id}
        Name: #{activity.name}
        Type: #{activity.activity_type}
        Duration: #{activity.duration} minutes
        Description: #{activity.description}
        Opening hours: #{activity.opening_hours}
      ACTIVITY
    end.join("\n\n")

    <<~PROMPT
      You are a travel itinerary planner for Paris.

      TRIP INFORMATION:
      - Destination: #{@trip.destination}
      - Start date: #{@trip.start_date}
      - End date: #{@trip.end_date}
      - Duration: #{(@trip.end_date - @trip.start_date).to_i + 1} days

      APPROVED ACTIVITIES:
      #{activities_str}

      TASK:
      Create a detailed day-by-day itinerary organizing these activities across the trip dates.
      Consider:
      - Activity duration and opening hours
      - Logical order (breakfast places in morning, restaurants at lunch/dinner time, etc.)
      - Geographic proximity when possible
      - Balanced distribution across days

      IMPORTANT - RETURN FORMAT:
      Return ONLY a valid JSON array with this exact structure:
      [
        {
          "activity_id": 1,
          "date": "#{@trip.start_date}",
          "time": "09:00",
          "position": 1
        },
        {
          "activity_id": 5,
          "date": "#{@trip.start_date}",
          "time": "14:00",
          "position": 2
        }
      ]

      Rules:
      - Use 24-hour time format (HH:MM)
      - Dates must be between #{@trip.start_date} and #{@trip.end_date}
      - Position starts at 1 and increments for each activity
      - No explanations, no markdown, just the JSON array
    PROMPT
  end

  def ask_llm(prompt)
    chat = RubyLLM.chat(model: "gpt-4o")
    response = chat.ask(prompt)

    # Parser la réponse JSON
    JSON.parse(response.content)
  rescue JSON::ParserError => e
    Rails.logger.error "Failed to parse LLM itinerary response: #{e.message}"
    Rails.logger.error "Response was: #{response.content}"
    nil
  rescue => e
    Rails.logger.error "Failed to call LLM for itinerary: #{e.message}"
    nil
  end

  def create_itinerary(schedule)
    # Créer l'objet Itinerary
    itinerary = Itinerary.create!(
      trip: @trip,
      system_prompt: "Generated itinerary based on approved recommendations"
    )

    # Créer les ItineraryItems
    schedule.each do |item|
      ItineraryItem.create!(
        itinerary: itinerary,
        activity_item_id: item["activity_id"],
        date: Date.parse(item["date"]),
        time: Time.parse(item["time"]),
        position: item["position"]
      )
    end

    Rails.logger.info "Created itinerary #{itinerary.id} with #{schedule.count} items for trip #{@trip.id}"
    itinerary
  end
end

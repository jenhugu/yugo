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
      You are a travel itinerary planner for #{@trip.destination}.

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

      MANDATORY MEAL CONSTRAINTS:
      - EVERY day must have a food/restaurant activity between 12:00-14:00 (lunch)
      - EVERY day must have a food/restaurant activity between 19:00-21:00 (dinner)
      - Food activities include: restaurants, cafés, food markets, or any activity with food-related types
      - These meal slots are NON-NEGOTIABLE and must be respected for each day of the trip

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

      CRITICAL RULES:
      - Return ONLY the raw JSON array
      - Do NOT wrap in markdown code blocks (no ```json or ```)
      - Do NOT add any explanations before or after the JSON
      - Use 24-hour time format (HH:MM)
      - Dates must be between #{@trip.start_date} and #{@trip.end_date}
      - Position starts at 1 and increments for each activity on each day
      - Do NOT use null for activity_id - only use IDs from the approved activities list above
      - Ensure valid JSON syntax (no trailing commas)
    PROMPT
  end

  def ask_llm(prompt)
    chat = RubyLLM.chat(model: "gpt-4o")
    response = chat.ask(prompt)

    # Nettoyer la réponse en supprimant les balises markdown
    content = response.content.strip

    # Supprimer les balises ```json et ``` si présentes
    content = content.gsub(/^```json\s*\n?/, '').gsub(/\n?```\s*$/, '')

    # Parser la réponse JSON
    JSON.parse(content)
  rescue JSON::ParserError => e
    Rails.logger.error "Failed to parse LLM itinerary response: #{e.message}"
    Rails.logger.error "Response was: #{response&.content || 'nil'}"
    Rails.logger.error "Cleaned content was: #{content}" if content
    nil
  rescue => e
    Rails.logger.error "Failed to call LLM for itinerary: #{e.message}"
    Rails.logger.error e.backtrace.first(5).join("\n")
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

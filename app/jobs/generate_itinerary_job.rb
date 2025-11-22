class GenerateItineraryJob < ApplicationJob
  queue_as :default

  def perform(recommendation_id)
    recommendation = Recommendation.find(recommendation_id)
    ItineraryGenerator.new(recommendation).call
  end
end

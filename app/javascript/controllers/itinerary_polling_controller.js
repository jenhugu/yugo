import { Controller } from "@hotwired/stimulus"

/**
 * Stimulus controller for polling itinerary generation status.
 *
 * This controller is attached to the "Generating itinerary..." button and polls
 * the server every few seconds to check if the itinerary has been generated.
 *
 * How it works:
 * 1. When the controller connects (button is displayed), polling starts automatically
 * 2. Every 3 seconds, it fetches the itinerary_status endpoint
 * 3. If the server returns 204 (No Content), the itinerary is still generating → continue polling
 * 4. If the server returns 200 with HTML, the itinerary is ready → replace the button
 * 5. Polling stops automatically when the button is replaced (controller disconnects)
 *
 * Usage in HTML:
 *   <span data-controller="itinerary-polling"
 *         data-itinerary-polling-url-value="/trips/123/itinerary_status">
 *     Generating itinerary...
 *   </span>
 */
export default class extends Controller {
  static values = {
    url: String,                              // The polling endpoint URL
    interval: { type: Number, default: 3000 } // Polling interval in ms (default: 3 seconds)
  }

  connect() {
    // Start polling when the controller is attached to the DOM
    this.startPolling()
  }

  disconnect() {
    // Stop polling when the controller is removed from the DOM
    // This happens automatically when the button is replaced with the new HTML
    this.stopPolling()
  }

  startPolling() {
    // Immediately check once, then set up interval
    this.checkStatus()

    this.timer = setInterval(() => {
      this.checkStatus()
    }, this.intervalValue)
  }

  stopPolling() {
    if (this.timer) {
      clearInterval(this.timer)
      this.timer = null
    }
  }

  async checkStatus() {
    try {
      const response = await fetch(this.urlValue)

      if (response.ok && response.status === 200) {
        // Itinerary is ready - replace the button with the new HTML
        const html = await response.text()
        this.element.outerHTML = html
        // Note: No need to call stopPolling() here because replacing outerHTML
        // removes this element from the DOM, which triggers disconnect()
      }
      // If response is 204 (No Content), continue polling - itinerary not ready yet
    } catch (error) {
      // Log error but continue polling - might be a temporary network issue
      console.error("Error checking itinerary status:", error)
    }
  }
}

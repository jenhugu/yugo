import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  async like() {
    await this.submitReview("like")
  }

  async dislike() {
    await this.submitReview("dislike")
  }

  async submitReview(action) {
    const itemId = this.element.dataset.itemId
    const url = `/recommendation_items/${itemId}/${action}`

    try {
      const response = await fetch(url, {
        method: "PATCH",
        headers: {
          "X-CSRF-Token": this.getCSRFToken()
        }
      })

      if (response.ok) {
        // Si c'est 204 No Content, recharger la page
        if (response.status === 204) {
          window.location.reload()
          return
        }

        // Si c'est du JSON
        const contentType = response.headers.get("content-type")
        if (contentType && contentType.includes("application/json")) {
          const data = await response.json()
          if (data.completed) {
            // Rediriger vers My trips avec le flash
            this.redirectWithFlash(data.message)
          }
        }
      } else {
        console.error("Request failed with status:", response.status)
      }
    } catch (error) {
      console.error("Error:", error)
    }
  }

  redirectWithFlash(message) {
    // Stocker le flash en session storage
    sessionStorage.setItem("flash_notice", message)
    window.location.href = "/trips"
  }

  getCSRFToken() {
    return document.querySelector('meta[name="csrf-token"]').content
  }
}

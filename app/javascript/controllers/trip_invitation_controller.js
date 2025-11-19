import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { userTripStatusId: Number }

  accept(event) {
    event.preventDefault()

    const button = event.currentTarget
    button.disabled = true
    button.textContent = "Accepting..."

    const url = `/user_trip_statuses/${this.userTripStatusIdValue}/accept_invitation`
    const csrfToken = document.querySelector("[name='csrf-token']").content

    fetch(url, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": csrfToken
      },
      redirect: "manual"
    })
    .then(response => {
      // Chercher le header Location pour le redirect
      const location = response.headers.get("location")
      if (location) {
        // Naviguer vers l'URL du redirect
        window.location.href = location
      } else {
        throw new Error("No redirect location provided")
      }
    })
    .catch(error => {
      console.error("Error:", error)
      button.disabled = false
      button.textContent = "Accept"
      this.showFlashMessage("Something went wrong", "alert")
    })
  }

  decline(event) {
    event.preventDefault()
    // À REVOIR DANS LE CADRE DE L'US SUR LA GESTION DU DECLINE
    console.log("Decline clicked - not implemented yet")
  }

  showFlashMessage(message, type) {
  // Déterminer la classe en fonction du type
  const flashClass = type === "notice" ? "notice-flash" : "alert-flash"
  const buttonClass = type === "notice" ? "btn-close-notice-flash" : "btn-close-flash"

  // Créer un élément flash message
  const flashDiv = document.createElement("div")
  flashDiv.className = flashClass
  flashDiv.innerHTML = `
    ${message}
    <button class="${buttonClass}" aria-label="Close">×</button>
  `

  // L'insérer en haut de la page
  document.body.insertAdjacentElement("afterbegin", flashDiv)

  // Ajouter l'événement pour fermer manuellement
  const closeBtn = flashDiv.querySelector("button")
  closeBtn.addEventListener("click", () => {
    flashDiv.style.transition = "opacity 0.3s"
    flashDiv.style.opacity = "0"
    setTimeout(() => flashDiv.remove(), 300)
  })

  // Le faire disparaître automatiquement après 3 secondes
  setTimeout(() => {
    flashDiv.style.transition = "opacity 0.3s"
    flashDiv.style.opacity = "0"
    setTimeout(() => flashDiv.remove(), 300)
  }, 3000)
}
}

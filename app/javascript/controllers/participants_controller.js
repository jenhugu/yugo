import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    // Compteur pour suivre le nombre de participants
    // On commence à 2 car il y a déjà Traveler #1 et #2
    this.participantCount = 2
  }

  add(event) {
    event.preventDefault()
    this.participantCount++

    // Créer le nouveau champ
    const newField = document.createElement('div')
    newField.className = 'trips-form__field'
    newField.innerHTML = `
      <label for="participant_emails_${this.participantCount}">Traveler #${this.participantCount}</label>
      <input type="email" name="participant_emails[]" placeholder="email@example.com" id="participant_emails_${this.participantCount}">
    `

    // Ajouter le champ au container
    this.containerTarget.appendChild(newField)
  }
}

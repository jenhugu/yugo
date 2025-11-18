import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle(event) {
    event.preventDefault()
    this.menuTarget.classList.toggle("show")
  }

  hide(event) {
    // Ne ferme pas si on clique à l'intérieur du dropdown
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.remove("show")
    }
  }

  disconnect() {
    // Nettoie l'event listener quand le controller est détruit
    document.removeEventListener("click", this.hide)
  }
}

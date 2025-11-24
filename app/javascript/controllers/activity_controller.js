import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"]

  toggle(event) {
    // Prevent the browser's default behavior of toggling the checkbox
    // when clicking on the label (but allow it if clicking directly on checkbox)
    if (event.target !== this.checkboxTarget) {
      event.preventDefault()
    }

    const checkbox = this.checkboxTarget
    checkbox.checked = !checkbox.checked

    this.element.classList.toggle("selected", checkbox.checked)
  }
}

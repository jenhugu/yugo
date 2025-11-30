import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["range", "value"]
  static values = { initial: Number }

  connect() {
    this.updateDisplay()
    this.rangeTarget.addEventListener('input', () => this.updateDisplay())
  }

  updateDisplay() {
    this.valueTarget.textContent = `${this.rangeTarget.value}€`
  }

  update() {
    this.updateDisplay()
  }
}

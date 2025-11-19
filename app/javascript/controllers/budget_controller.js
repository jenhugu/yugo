import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["range", "value"]
  static values = { initial: Number }

  connect() {
    this.valueTarget.textContent = `${this.initialValue}€`
  }

  update() {
    this.valueTarget.textContent = `${this.rangeTarget.value}€`
  }
}

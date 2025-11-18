import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "value"]

  connect() {
    this.update()
  }

  update() {
    this.valueTargets.forEach((span, i) => {
      span.textContent = this.inputTargets[i].value
    })
  }
}

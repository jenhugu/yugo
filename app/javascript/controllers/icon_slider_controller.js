import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["track", "thumb", "input"]

  connect() {
    this.updateThumbPosition()
  }

  updateThumbPosition() {
    const value = parseInt(this.inputTarget.value)
    const min = parseInt(this.inputTarget.min) || 0
    const max = parseInt(this.inputTarget.max) || 100
    const percentage = ((value - min) / (max - min)) * 100

    // Account for thumb width to keep it within bounds
    const thumbWidth = this.thumbTarget.offsetWidth
    const trackWidth = this.trackTarget.offsetWidth
    const maxOffset = trackWidth - thumbWidth
    const offset = (percentage / 100) * maxOffset

    this.thumbTarget.style.left = `${offset}px`
  }

  onInput() {
    this.updateThumbPosition()
  }

  onTrackClick(event) {
    const rect = this.trackTarget.getBoundingClientRect()
    const clickX = event.clientX - rect.left
    const percentage = (clickX / rect.width) * 100

    const min = parseInt(this.inputTarget.min) || 0
    const max = parseInt(this.inputTarget.max) || 100
    const value = Math.round((percentage / 100) * (max - min) + min)

    this.inputTarget.value = Math.max(min, Math.min(max, value))
    this.updateThumbPosition()
  }

  startDrag(event) {
    event.preventDefault()
    this.isDragging = true

    const moveHandler = (e) => this.onDrag(e)
    const upHandler = () => {
      this.isDragging = false
      document.removeEventListener('mousemove', moveHandler)
      document.removeEventListener('mouseup', upHandler)
      document.removeEventListener('touchmove', moveHandler)
      document.removeEventListener('touchend', upHandler)
    }

    document.addEventListener('mousemove', moveHandler)
    document.addEventListener('mouseup', upHandler)
    document.addEventListener('touchmove', moveHandler)
    document.addEventListener('touchend', upHandler)
  }

  onDrag(event) {
    if (!this.isDragging) return

    const clientX = event.type.includes('touch') ? event.touches[0].clientX : event.clientX
    const rect = this.trackTarget.getBoundingClientRect()
    const clickX = clientX - rect.left
    const percentage = Math.max(0, Math.min(100, (clickX / rect.width) * 100))

    const min = parseInt(this.inputTarget.min) || 0
    const max = parseInt(this.inputTarget.max) || 100
    const value = Math.round((percentage / 100) * (max - min) + min)

    this.inputTarget.value = Math.max(min, Math.min(max, value))
    this.updateThumbPosition()
  }
}

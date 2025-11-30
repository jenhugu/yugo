import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "modal"]
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    this.map = null
    this.mapMarkers = []
  }

  open() {
    this.modalTarget.classList.add("map-modal--open")
    document.body.style.overflow = "hidden"

    // Initialize map after modal is visible
    setTimeout(() => {
      this.initializeMap()
    }, 100)
  }

  close() {
    this.modalTarget.classList.remove("map-modal--open")
    document.body.style.overflow = ""
  }

  closeOnOverlay(event) {
    if (event.target === this.modalTarget) {
      this.close()
    }
  }

  initializeMap() {
    if (this.map) {
      this.map.resize()
      return
    }

    mapboxgl.accessToken = this.apiKeyValue

    // Calculate center from markers
    const markers = this.markersValue
    let center = [2.3522, 48.8566] // Paris default

    if (markers.length > 0) {
      const lngs = markers.map(m => m.lng)
      const lats = markers.map(m => m.lat)
      center = [
        (Math.min(...lngs) + Math.max(...lngs)) / 2,
        (Math.min(...lats) + Math.max(...lats)) / 2
      ]
    }

    this.map = new mapboxgl.Map({
      container: this.containerTarget,
      style: 'mapbox://styles/mapbox/streets-v12',
      center: center,
      zoom: 12
    })

    this.map.addControl(new mapboxgl.NavigationControl())

    // Add markers
    this.addMarkers()

    // Fit bounds to show all markers
    if (markers.length > 1) {
      const bounds = new mapboxgl.LngLatBounds()
      markers.forEach(marker => {
        bounds.extend([marker.lng, marker.lat])
      })
      this.map.fitBounds(bounds, { padding: 50 })
    }
  }

  addMarkers() {
    const markers = this.markersValue

    markers.forEach((markerData, index) => {
      // Create custom marker element
      const el = document.createElement('div')
      el.className = 'map-marker'
      el.innerHTML = `<span class="map-marker__number">${index + 1}</span>`

      // Create popup
      const popup = new mapboxgl.Popup({ offset: 25 })
        .setHTML(`
          <div class="map-popup">
            <h4 class="map-popup__title">${markerData.name}</h4>
            <p class="map-popup__type">${markerData.type}</p>
            <p class="map-popup__address">${markerData.address}</p>
          </div>
        `)

      // Add marker to map
      const marker = new mapboxgl.Marker(el)
        .setLngLat([markerData.lng, markerData.lat])
        .setPopup(popup)
        .addTo(this.map)

      this.mapMarkers.push(marker)
    })
  }

  disconnect() {
    if (this.map) {
      this.map.remove()
      this.map = null
    }
  }
}

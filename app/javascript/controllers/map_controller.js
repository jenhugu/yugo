import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "modal", "sidebar", "daysList", "hotelInput", "hotelStatus"]
  static values = {
    apiKey: String,
    days: Array,
    tripId: Number
  }

  connect() {
    this.map = null
    this.mapMarkers = []
    this.selectedDay = null
    this.hotelMarker = null
  }

  open() {
    this.modalTarget.classList.add("map-modal--open")
    document.body.style.overflow = "hidden"

    // Initialize map after modal is visible
    setTimeout(() => {
      this.initializeMap()
      this.renderDaysList()
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

  renderDaysList() {
    const days = this.daysValue
    this.daysListTarget.innerHTML = ""

    days.forEach((dayData, index) => {
      const dayItem = document.createElement("div")
      dayItem.className = "map-sidebar__day"
      dayItem.dataset.dayIndex = index
      dayItem.innerHTML = `
        <div class="map-sidebar__day-header">
          <span class="map-sidebar__day-number">Day ${dayData.day}</span>
          <span class="map-sidebar__day-date">${dayData.date || ""}</span>
          <i class="fa-solid fa-chevron-down map-sidebar__day-arrow"></i>
        </div>
        <div class="map-sidebar__day-activities">
          ${dayData.markers.map(marker => `
            <div class="map-sidebar__activity" data-lat="${marker.lat}" data-lng="${marker.lng}">
              <div class="map-sidebar__activity-image">
                ${marker.image
                  ? `<img src="${marker.image}" alt="${marker.name}" />`
                  : `<div class="map-sidebar__activity-placeholder"><i class="fa-solid fa-image"></i></div>`
                }
              </div>
              <div class="map-sidebar__activity-info">
                <span class="map-sidebar__activity-position">${marker.position}</span>
                <span class="map-sidebar__activity-name">${marker.name}</span>
              </div>
            </div>
          `).join("")}
        </div>
      `

      // Add click event to toggle day
      const header = dayItem.querySelector(".map-sidebar__day-header")
      header.addEventListener("click", () => this.toggleDay(index))

      // Add click events to activities to center map
      const activities = dayItem.querySelectorAll(".map-sidebar__activity")
      activities.forEach(activity => {
        activity.addEventListener("click", (e) => {
          e.stopPropagation()
          const lat = parseFloat(activity.dataset.lat)
          const lng = parseFloat(activity.dataset.lng)
          this.centerOnMarker(lat, lng)
        })
      })

      this.daysListTarget.appendChild(dayItem)
    })

    // Open first day by default
    if (days.length > 0) {
      this.toggleDay(0)
    }
  }

  toggleDay(dayIndex) {
    const days = this.daysValue
    const dayItems = this.daysListTarget.querySelectorAll(".map-sidebar__day")

    dayItems.forEach((item, index) => {
      if (index === dayIndex) {
        const isOpen = item.classList.contains("map-sidebar__day--open")
        if (isOpen) {
          item.classList.remove("map-sidebar__day--open")
          this.selectedDay = null
          // Show all markers when closing
          this.showAllMarkers()
        } else {
          item.classList.add("map-sidebar__day--open")
          this.selectedDay = dayIndex
          // Filter markers for this day
          this.showMarkersForDay(dayIndex)
        }
      } else {
        item.classList.remove("map-sidebar__day--open")
      }
    })
  }

  showMarkersForDay(dayIndex) {
    const days = this.daysValue
    const dayData = days[dayIndex]

    // Clear existing markers
    this.clearMarkers()

    // Add markers for this day only
    this.addMarkersForData(dayData.markers)

    // Fit bounds to show these markers
    if (dayData.markers.length > 0) {
      this.fitBoundsToMarkers(dayData.markers)
    }
  }

  showAllMarkers() {
    const days = this.daysValue
    const allMarkers = days.flatMap(day => day.markers)

    // Clear existing markers
    this.clearMarkers()

    // Add all markers
    this.addMarkersForData(allMarkers)

    // Fit bounds
    if (allMarkers.length > 0) {
      this.fitBoundsToMarkers(allMarkers)
    }
  }

  centerOnMarker(lat, lng) {
    if (this.map) {
      this.map.flyTo({
        center: [lng, lat],
        zoom: 15,
        duration: 1000
      })

      // Find and open the popup for this marker
      this.mapMarkers.forEach(marker => {
        const lngLat = marker.getLngLat()
        if (Math.abs(lngLat.lat - lat) < 0.0001 && Math.abs(lngLat.lng - lng) < 0.0001) {
          marker.togglePopup()
        }
      })
    }
  }

  initializeMap() {
    if (this.map) {
      this.map.resize()
      return
    }

    mapboxgl.accessToken = this.apiKeyValue

    // Calculate center from all markers
    const days = this.daysValue
    const allMarkers = days.flatMap(day => day.markers)
    let center = [2.3522, 48.8566] // Paris default

    if (allMarkers.length > 0) {
      const lngs = allMarkers.map(m => m.lng)
      const lats = allMarkers.map(m => m.lat)
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

    // Load saved hotel after map is ready
    this.map.on('load', () => {
      this.loadSavedHotel()
    })
  }

  clearMarkers() {
    this.mapMarkers.forEach(marker => marker.remove())
    this.mapMarkers = []
  }

  addMarkersForData(markers) {
    markers.forEach((markerData) => {
      // Create custom marker element
      const el = document.createElement('div')
      el.className = 'map-marker'
      el.innerHTML = `<span class="map-marker__number">${markerData.position}</span>`

      // Create popup with image
      const popupContent = `
        <div class="map-popup">
          ${markerData.image
            ? `<div class="map-popup__image"><img src="${markerData.image}" alt="${markerData.name}" /></div>`
            : ''
          }
          <div class="map-popup__content">
            <h4 class="map-popup__title">${markerData.name}</h4>
            <p class="map-popup__type">${markerData.type || ''}</p>
            <p class="map-popup__address">${markerData.address || ''}</p>
          </div>
        </div>
      `

      const popup = new mapboxgl.Popup({ offset: 25, maxWidth: '280px' })
        .setHTML(popupContent)

      // Add marker to map
      const marker = new mapboxgl.Marker(el)
        .setLngLat([markerData.lng, markerData.lat])
        .setPopup(popup)
        .addTo(this.map)

      this.mapMarkers.push(marker)
    })
  }

  fitBoundsToMarkers(markers) {
    if (markers.length === 1) {
      this.map.flyTo({
        center: [markers[0].lng, markers[0].lat],
        zoom: 14,
        duration: 1000
      })
    } else if (markers.length > 1) {
      const bounds = new mapboxgl.LngLatBounds()
      markers.forEach(marker => {
        bounds.extend([marker.lng, marker.lat])
      })
      this.map.fitBounds(bounds, { padding: 50, duration: 1000 })
    }
  }

  disconnect() {
    if (this.map) {
      this.map.remove()
      this.map = null
    }
  }

  async addHotelMarker() {
    const address = this.hotelInputTarget.value.trim()
    if (!address) return

    this.hotelStatusTarget.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Searching...'
    this.hotelStatusTarget.className = 'map-sidebar__hotel-status map-sidebar__hotel-status--loading'

    try {
      // Use Mapbox Geocoding API
      const response = await fetch(
        `https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(address)}.json?access_token=${this.apiKeyValue}&limit=1`
      )
      const data = await response.json()

      if (data.features && data.features.length > 0) {
        const [lng, lat] = data.features[0].center
        const placeName = data.features[0].place_name

        // Remove existing hotel marker if any
        if (this.hotelMarker) {
          this.hotelMarker.remove()
        }

        // Create hotel marker element
        const el = document.createElement('div')
        el.className = 'map-marker map-marker--hotel'
        el.innerHTML = '<i class="fa-solid fa-hotel"></i>'

        // Create popup
        const popup = new mapboxgl.Popup({ offset: 25 })
          .setHTML(`
            <div class="map-popup">
              <div class="map-popup__content">
                <h4 class="map-popup__title">My Hotel</h4>
                <p class="map-popup__address">${placeName}</p>
              </div>
            </div>
          `)

        // Add marker to map
        this.hotelMarker = new mapboxgl.Marker(el)
          .setLngLat([lng, lat])
          .setPopup(popup)
          .addTo(this.map)

        // Center map on hotel
        this.map.flyTo({
          center: [lng, lat],
          zoom: 14,
          duration: 1000
        })

        this.hotelStatusTarget.innerHTML = '<i class="fa-solid fa-check"></i> Hotel added to map'
        this.hotelStatusTarget.className = 'map-sidebar__hotel-status map-sidebar__hotel-status--success'

        // Save to localStorage for persistence (specific to this trip)
        const tripId = this.tripIdValue
        localStorage.setItem(`yugo_hotel_address_${tripId}`, address)
        localStorage.setItem(`yugo_hotel_coords_${tripId}`, JSON.stringify({ lat, lng, placeName }))

      } else {
        this.hotelStatusTarget.innerHTML = '<i class="fa-solid fa-exclamation-circle"></i> Address not found'
        this.hotelStatusTarget.className = 'map-sidebar__hotel-status map-sidebar__hotel-status--error'
      }
    } catch (error) {
      console.error('Geocoding error:', error)
      this.hotelStatusTarget.innerHTML = '<i class="fa-solid fa-exclamation-circle"></i> Error searching address'
      this.hotelStatusTarget.className = 'map-sidebar__hotel-status map-sidebar__hotel-status--error'
    }
  }

  loadSavedHotel() {
    const tripId = this.tripIdValue
    const savedAddress = localStorage.getItem(`yugo_hotel_address_${tripId}`)
    const savedCoords = localStorage.getItem(`yugo_hotel_coords_${tripId}`)

    if (savedAddress && savedCoords) {
      this.hotelInputTarget.value = savedAddress
      const { lat, lng, placeName } = JSON.parse(savedCoords)

      // Create hotel marker
      const el = document.createElement('div')
      el.className = 'map-marker map-marker--hotel'
      el.innerHTML = '<i class="fa-solid fa-hotel"></i>'

      const popup = new mapboxgl.Popup({ offset: 25 })
        .setHTML(`
          <div class="map-popup">
            <div class="map-popup__content">
              <h4 class="map-popup__title">My Hotel</h4>
              <p class="map-popup__address">${placeName}</p>
            </div>
          </div>
        `)

      this.hotelMarker = new mapboxgl.Marker(el)
        .setLngLat([lng, lat])
        .setPopup(popup)
        .addTo(this.map)

      this.hotelStatusTarget.innerHTML = '<i class="fa-solid fa-check"></i> Hotel on map'
      this.hotelStatusTarget.className = 'map-sidebar__hotel-status map-sidebar__hotel-status--success'
    }
  }
}

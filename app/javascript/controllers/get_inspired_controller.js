import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log('GetInsiredController connected', this.element)

    this.isLoading = false

    // Créer un sentinel element au bas de la grille pour détecter quand scroller
    this.createSentinel()

    // Observer l'intersection du sentinel avec le viewport
    this.observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        console.log('Intersection detected', entry.isIntersecting)
        if (entry.isIntersecting && !this.isLoading) {
          this.loadMore()
        }
      })
    }, {
      rootMargin: '200px' // Charger 200px avant que l'utilisateur atteigne le bas
    })

    this.observer.observe(this.sentinel)
  }

  createSentinel() {
    this.sentinel = document.createElement('div')
    this.sentinel.className = 'get-inspired-sentinel'
    this.element.appendChild(this.sentinel)
    console.log('Sentinel created and added')
  }

  async loadMore() {
    console.log('LoadMore called')
    if (this.isLoading) return

    this.isLoading = true

    try {
      const response = await fetch('/get-inspired/more', {
        headers: {
          'Accept': 'text/html'
        }
      })

      console.log('Fetch response:', response.status)

      if (response.ok) {
        const html = await response.text()
        console.log('HTML received:', html)

        // Insérer le HTML avant le sentinel
        const template = document.createElement('template')
        template.innerHTML = html

        // Ajouter chaque carte à la grille
        const cards = template.content.querySelectorAll('.get-inspired-card')
        console.log('Cards found:', cards.length)

        cards.forEach(card => {
          this.element.insertBefore(card.cloneNode(true), this.sentinel)
        })

        // Repositionner le sentinel après les nouvelles cartes
        this.observer.unobserve(this.sentinel)
        this.element.removeChild(this.sentinel)
        this.createSentinel()
        this.observer.observe(this.sentinel)
      }
    } catch (error) {
      console.error('Error loading more activities:', error)
    } finally {
      this.isLoading = false
    }
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }
}

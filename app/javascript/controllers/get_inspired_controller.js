import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Créer un sentinel element au bas de la grille pour détecter quand scroller
    this.sentinel = document.createElement('div')
    this.sentinel.className = 'get-inspired-sentinel'
    this.element.appendChild(this.sentinel)

    // Observer l'intersection du sentinel avec le viewport
    this.observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          this.loadMore()
        }
      })
    }, {
      rootMargin: '200px' // Charger 200px avant que l'utilisateur atteigne le bas
    })

    this.observer.observe(this.sentinel)
  }

  async loadMore() {
    try {
      const response = await fetch('/get-inspired/more', {
        headers: {
          'Accept': 'text/html'
        }
      })

      if (response.ok) {
        const html = await response.text()

        // Insérer le HTML avant le sentinel
        const template = document.createElement('template')
        template.innerHTML = html

        // Ajouter chaque carte à la grille
        template.content.querySelectorAll('.get-inspired-card').forEach(card => {
          this.element.insertBefore(card.cloneNode(true), this.sentinel)
        })
      }
    } catch (error) {
      console.error('Error loading more activities:', error)
    }
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }
}

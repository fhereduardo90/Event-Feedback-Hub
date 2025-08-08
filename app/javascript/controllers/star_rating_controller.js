import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["star", "input"]

  connect() {
    this.setupStars()
  }

  setupStars() {
    this.starTargets.forEach((star, index) => {
      star.addEventListener('click', this.handleClick.bind(this))
      star.addEventListener('mouseover', this.handleMouseover.bind(this))
      star.addEventListener('mouseout', this.handleMouseout.bind(this))
    })
    
    // Set initial star display if there's already a selected rating
    const checkedInput = this.inputTargets.find(input => input.checked)
    if (checkedInput) {
      this.updateStarDisplay(parseInt(checkedInput.value))
    }
  }

  handleClick(event) {
    const rating = parseInt(event.target.dataset.rating)
    const radioButton = event.target.previousElementSibling
    radioButton.checked = true
    this.updateStarDisplay(rating)
  }

  handleMouseover(event) {
    const rating = parseInt(event.target.dataset.rating)
    this.highlightStars(rating)
  }

  handleMouseout(event) {
    const checkedInput = this.inputTargets.find(input => input.checked)
    const currentRating = checkedInput ? parseInt(checkedInput.value) : 0
    this.updateStarDisplay(currentRating)
  }

  updateStarDisplay(rating) {
    this.starTargets.forEach((star, index) => {
      if (index < rating) {
        star.classList.remove('text-gray-300')
        star.classList.add('text-yellow-400')
      } else {
        star.classList.remove('text-yellow-400')
        star.classList.add('text-gray-300')
      }
    })
  }

  highlightStars(rating) {
    this.starTargets.forEach((star, index) => {
      if (index < rating) {
        star.classList.add('text-yellow-400')
      }
    })
  }
}
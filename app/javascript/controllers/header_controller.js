import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["header"]

  connect() {
    this.toggleClass()
    window.addEventListener("scroll", this.toggleClass)
  }

  disconnect() {
    window.removeEventListener("scroll", this.toggleClass)
  }

  toggleClass = () => {
    if (window.scrollY > 10) {
      this.headerTarget.classList.add("scroll")
    } else {
      this.headerTarget.classList.remove("scroll")
    }
  }
}

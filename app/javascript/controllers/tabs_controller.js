import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "box"]

  connect() {
    this.activateFromHash()
    window.addEventListener("hashchange", this.activateFromHash)
  }

  disconnect() {
    window.removeEventListener("hashchange", this.activateFromHash)
  }

  change(event) {
    const button = event.currentTarget
    const name = button.dataset.button
    this.activateTab(name)
    window.location.hash = name
  }

  activateFromHash = () => {
    const hash = window.location.hash.replace("#", "")
    if (hash) {
      this.activateTab(hash)
    }
  }

  activateTab(name) {
    this.buttonTargets.forEach(btn => {
      btn.classList.toggle("active", btn.dataset.button === name)
    })

    this.boxTargets.forEach(box => {
      box.classList.toggle("active", box.dataset.box === name)
    })
  }
}

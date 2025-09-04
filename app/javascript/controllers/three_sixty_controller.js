import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image"]

  connect() {
    this.currentFrame = 0
    this.totalFrames = this.imageTargets.length
    this.autoRotateInterval = null
    this.startX = null

    if (this.totalFrames > 0) {
      this.showFrame(this.currentFrame)
      this.startAutoRotate()
    }
  }

  showFrame(index) {
    this.imageTargets.forEach((img, i) => {
      img.style.display = i === index ? "block" : "none"
    })
  }

  startAutoRotate() {
    if (this.autoRotateInterval) return
    this.autoRotateInterval = setInterval(() => {
      this.currentFrame = (this.currentFrame + 1) % this.totalFrames
      this.showFrame(this.currentFrame)
    }, 1000)
  }

  stopAutoRotate() {
    if (this.autoRotateInterval) {
      clearInterval(this.autoRotateInterval)
      this.autoRotateInterval = null
    }
  }

  dragStart(event) {
    this.stopAutoRotate()
    this.startX = event.clientX || event.touches?.[0]?.clientX
    this.element.classList.add("dragging")
  }

  dragMove(event) {
    const clientX = event.clientX || event.touches?.[0]?.clientX
    if (!this.startX || !clientX) return

    const diff = clientX - this.startX
    if (Math.abs(diff) > 10) {
      this.currentFrame = diff > 0
        ? (this.currentFrame + 1) % this.totalFrames
        : (this.currentFrame - 1 + this.totalFrames) % this.totalFrames
      this.showFrame(this.currentFrame)
      this.startX = clientX
    }
  }

  dragEnd() {
    this.element.classList.remove("dragging")
    this.startX = null
  }
}

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["video", "playButton"]

  connect() {
    this.playButtonTarget.style.display = "block"
  }

  play() {
    this.videoTarget.play()
    this.playButtonTarget.style.display = "none"
  }

  pause() {
    this.videoTarget.pause()
    this.playButtonTarget.style.display = "block"
  }

  toggle() {
    if (this.videoTarget.paused) {
      this.play()
    } else {
      this.pause()
    }
  }
}

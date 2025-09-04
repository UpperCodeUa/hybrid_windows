import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["video", "playButton"]

  connect() {
    this.playButtonTarget.style.display = "block"

    // коли відео закінчилося
    this.videoTarget.addEventListener("ended", () => {
      this.showPlayButton()
    })
  }

  play() {
    this.videoTarget.play()
    this.hidePlayButton()
  }

  pause() {
    this.videoTarget.pause()
    this.showPlayButton()
  }

  toggle() {
    if (this.videoTarget.paused) {
      this.play()
    } else {
      this.pause()
    }
  }

  showPlayButton() {
    this.playButtonTarget.style.display = "block"
  }

  hidePlayButton() {
    this.playButtonTarget.style.display = "none"
  }
}

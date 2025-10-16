// app/javascript/controllers/hcaptcha_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  connect() {
  }

  submit(event) {
    const hcaptchaResponse = document.querySelector('#hcaptcha-response')
    const hcaptchaWidget = hcaptcha.getResponse()

    if (hcaptchaWidget === '') {
      event.preventDefault()
      alert("Будь ласка, підтвердіть, що ви не робот.")
    } else {
      hcaptchaResponse.value = hcaptchaWidget
    }
  }
}

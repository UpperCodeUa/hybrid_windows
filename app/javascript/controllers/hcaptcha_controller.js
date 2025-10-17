import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  connect() {
    this.renderCaptcha()
    document.addEventListener("turbo:load", () => this.renderCaptcha())
  }

  renderCaptcha() {
    if (typeof hcaptcha === "undefined") {
      window.onloadCaptcha = () => this.renderCaptcha()
      return
    }

    const captchaElements = document.querySelectorAll(".h-captcha")

    captchaElements.forEach(el => {
      if (!el.hasAttribute("data-hcaptcha-rendered")) {
        hcaptcha.render(el, {
          sitekey: el.dataset.sitekey
        })
        el.setAttribute("data-hcaptcha-rendered", "true")
      }
    })
  }

  submit(event) {
    const hcaptchaResponse = document.querySelector('#hcaptcha-response')
    const hcaptchaWidget = hcaptcha.getResponse()

    if (!hcaptchaWidget || hcaptchaWidget === '') {
      event.preventDefault()
      alert("Будь ласка, підтвердіть, що ви не робот.")
    } else if (hcaptchaResponse) {
      hcaptchaResponse.value = hcaptchaWidget
    }
  }
}

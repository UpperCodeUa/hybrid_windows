import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  connect() {
    this.renderCaptcha()

    document.addEventListener("turbo:load", () => this.renderCaptcha())
    document.addEventListener("turbo:before-cache", () => this.destroyCaptcha())
  }

  renderCaptcha() {
    if (typeof hcaptcha === "undefined") return

    const captchaElements = document.querySelectorAll(".h-captcha")

    captchaElements.forEach(el => {
      // Якщо ще не відрендерено — рендеримо
      if (!el.hasAttribute("data-hcaptcha-rendered")) {
        const widgetId = hcaptcha.render(el, {
          sitekey: el.dataset.sitekey
        })
        el.dataset.hcaptchaWidgetId = widgetId
        el.setAttribute("data-hcaptcha-rendered", "true")
      }
    })
  }

  destroyCaptcha() {
    const captchaElements = document.querySelectorAll(".h-captcha[data-hcaptcha-rendered='true']")
    captchaElements.forEach(el => {
      const widgetId = el.dataset.hcaptchaWidgetId
      if (widgetId) {
        try {
          hcaptcha.reset(widgetId)
        } catch (e) {
          console.warn("hCaptcha reset failed:", e)
        }
      }
      el.removeAttribute("data-hcaptcha-rendered")
    })
  }

  submit(event) {
    const captchaElements = document.querySelectorAll(".h-captcha[data-hcaptcha-rendered='true']")
    let valid = false

    captchaElements.forEach(el => {
      const widgetId = el.dataset.hcaptchaWidgetId
      const response = hcaptcha.getResponse(widgetId)

      if (response && response.trim() !== "") {
        valid = true
        const hcaptchaResponse = document.querySelector("#hcaptcha-response")
        if (hcaptchaResponse) hcaptchaResponse.value = response
      }
    })

    if (!valid) {
      event.preventDefault()
      alert("Будь ласка, підтвердіть, що ви не робот.")
    }
  }
}

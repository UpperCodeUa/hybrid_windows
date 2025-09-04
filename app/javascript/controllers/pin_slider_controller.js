import { Controller } from "@hotwired/stimulus"
import Swiper from "swiper/bundle";

export default class extends Controller {
  static targets = ["container"]

  connect() {
    const vwToPx = (vw) => window.innerWidth * (vw / 100);
    this.swiper = new Swiper(this.containerTarget, {
      slidesPerView: "auto",
      spaceBetween: vwToPx(2),
      navigation: {
        nextEl: ".next-slide",
        prevEl: ".prev-slide",
      },
      pagination: {
        el: ".swiper-pagination",
        type: "progressbar",
      },
      breakpoints: {
        0: {
          spaceBetween: 14,
        },
        1024: {
          spaceBetween: vwToPx(1.667),
        }
      }
    })

    this.addPinListeners(this.containerTarget)
    this.updatePinnedBoxDisplay()
  }

  addPinListeners(root) {
    root.querySelectorAll(".pin").forEach(pin => {
      pin.addEventListener("click", (e) => this.pinSlide(e))
    })
  }

  pinSlide(event) {
    const pin = event.currentTarget
    const slide = pin.closest(".swiper-slide")
    const cart = slide.querySelector(".cart")
    const sliderBox = this.element
    const pinnedBox = document.querySelector(".pinned-box")

    if (slide.classList.contains("pinned")) {
      slide.classList.remove("pinned")
      pin.classList.remove("active")
      sliderBox.classList.remove("is-pinned")
      pinnedBox.innerHTML = ""
      this.updatePinnedBoxDisplay()
      return
    }

    this.containerTarget.querySelectorAll(".pin.active").forEach(p => p.classList.remove("active"))
    this.containerTarget.querySelectorAll(".swiper-slide.pinned").forEach(s => s.classList.remove("pinned"))
    sliderBox.classList.remove("is-pinned")
    pinnedBox.innerHTML = ""

    pin.classList.add("active")
    slide.classList.add("pinned")
    sliderBox.classList.add("is-pinned")

    const cartClone = cart.cloneNode(true)
    pinnedBox.appendChild(cartClone)

    const pinnedPin = cartClone.querySelector(".pin")
    pinnedPin.addEventListener("click", () => {
      slide.classList.remove("pinned")
      pin.classList.remove("active")
      sliderBox.classList.remove("is-pinned")
      pinnedBox.innerHTML = ""
      this.updatePinnedBoxDisplay()
    })
    pinnedPin.classList.add("active")

    this.updatePinnedBoxDisplay()
  }

  updatePinnedBoxDisplay() {
    const pinnedBox = document.querySelector(".pinned-box")
    if (!pinnedBox) return
    if (pinnedBox.children.length > 0) {
      pinnedBox.style.display = "block"
    } else {
      pinnedBox.style.display = "none"
    }
  }
}

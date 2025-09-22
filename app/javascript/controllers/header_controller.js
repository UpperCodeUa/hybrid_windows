import { Controller } from "@hotwired/stimulus"
import Swiper from "swiper/bundle";


export default class extends Controller {
  static targets = ["header", "menuButton", "mobileNav"]

  connect() {
    this.toggleClass()
    window.addEventListener("scroll", this.toggleClass)

    document.querySelectorAll('a[href^="#"]').forEach(link => {
      link.addEventListener("click", this.scrollToSection)
    })

    const swiper = new Swiper(".project-slider", {
      slidesPerView: "auto",
      spaceBetween: 32,
      loop: false,
      pagination: {
        el: ".swiper-pagination",
        type: "progressbar",
      },

      navigation: {
        nextEl: ".next-slide",
        prevEl: ".prev-slide",
      },
      breakpoints: {
        0: {
          slidesPerView: 1,
          spaceBetween: 16,
        },
        1024: {
          slidesPerView: "auto",
          spaceBetween: 32,
        }
      }

    });

    const swiper2 = new Swiper(".catalog-slider", {
      slidesPerView: "auto",
      spaceBetween: 0,
      loop: false,
      pagination: {
        el: ".swiper-pagination",
        type: "progressbar",
      },

      navigation: {
        nextEl: ".next-slide-catalog",
        prevEl: ".prev-slide-catalog",
      },
    });

    const swiper3 = new Swiper(".iframes-slider", {
      slidesPerView: "auto",
      spaceBetween: 0,
      loop: false,
      pagination: {
        el: ".swiper-pagination",
        type: "progressbar",
      },

      navigation: {
        nextEl: ".next-slide-iframes",
        prevEl: ".prev-slide-iframes",
      },
    });

    const swiper4 = new Swiper(".types-slider1", {
      slidesPerView: "auto",
      spaceBetween: 0,
      loop: false,
      pagination: {
        el: ".swiper-pagination",
        type: "progressbar",
      },

      navigation: {
        nextEl: ".next-slide-slider1",
        prevEl: ".prev-slide-slider1",
      },
    });

    const swiper5 = new Swiper(".types-slider2", {
      slidesPerView: "auto",
      spaceBetween: 0,
      loop: false,
      pagination: {
        el: ".swiper-pagination",
        type: "progressbar",
      },

      navigation: {
        nextEl: ".next-slide-slider2",
        prevEl: ".prev-slide-slider2",
      },
    });
  }

  disconnect() {
    window.removeEventListener("scroll", this.toggleClass)
    document.querySelectorAll('a[href^="#"]').forEach(link => {
      link.removeEventListener("click", this.scrollToSection)
    })
  }

  toggleClass = () => {
    if (window.scrollY > 10) {
      this.headerTarget.classList.add("scroll")
    } else {
      this.headerTarget.classList.remove("scroll")
    }
  }

  toggleMenu() {
    this.menuButtonTarget.classList.toggle("active")
    this.mobileNavTarget.classList.toggle("active")
    this.headerTarget.classList.toggle("active")
  }

  scrollToSection = (event) => {
    event.preventDefault()
    const targetId = event.currentTarget.getAttribute("href").substring(1)
    const targetElement = document.getElementById(targetId)

    if (targetElement) {
      targetElement.scrollIntoView({
        behavior: "smooth",
        block: "start"
      })
    }
  }
}

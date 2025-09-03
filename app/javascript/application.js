import "@hotwired/turbo-rails";
import "controllers";

import "trix";
import "@rails/actiontext";


import Swiper from "swiper/bundle";

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
  });

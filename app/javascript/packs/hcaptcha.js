document.addEventListener("turbo:load", function () {
  const form = document.querySelector('.form');
  if (!form) return;

  form.addEventListener('submit', function (event) {
    const hcaptchaResponse = document.querySelector('#hcaptcha-response');
    const hcaptchaWidget = hcaptcha.getResponse();

    if (hcaptchaWidget === '') {
      event.preventDefault();
      alert("Будь ласка, підтвердіть, що ви не робот.");
    } else {
      hcaptchaResponse.value = hcaptchaWidget;
    }
  });
});

import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="flash"
export default class extends Controller {
  static targets = ["alert"];

  connect() {
    setTimeout(() => {
      this.element.remove();
    }, 7000);
  }

  remove() {
    this.alertTarget.remove();
    this.element.remove();
  }
}

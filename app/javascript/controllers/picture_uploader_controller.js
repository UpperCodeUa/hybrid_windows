import { Controller } from '@hotwired/stimulus'

// Connects to data-controller='picture-uploader'
export default class extends Controller {
  static targets = ['filePreview', 'error'];

  showPreview(event) {
    const file = event.target.files[0];

    if (event.target.files.length < 0) return;

    this.filePreviewTarget.src           = URL.createObjectURL(file);
    this.filePreviewTarget.style.display = 'block';
  }
}

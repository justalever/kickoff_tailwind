import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['menu']

  toggleMenu(event) {
    this.menuTarget.classList.toggle('hidden')
  }

}

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sheet", "backdrop"]

  open() {
    this.backdropTarget.classList.remove("hidden")
    this.sheetTarget.classList.remove("hidden")

    setTimeout(() => {
      this.backdropTarget.classList.replace("opacity-0", "opacity-100")
      this.sheetTarget.classList.remove("translate-y-full")
    }, 10)
  }

  close() {
    this.sheetTarget.classList.add("translate-y-full", "hidden")
    this.backdropTarget.classList.replace("opacity-100", "opacity-0")

    setTimeout(() => {
      this.backdropTarget.classList.add("hidden")
    }, 300)
  }
}
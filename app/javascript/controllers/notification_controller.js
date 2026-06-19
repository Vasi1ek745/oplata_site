// app/javascript/controllers/notification_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toast"]
  
  connect() {
    // Автоматически скрываем через 4 секунды
    setTimeout(() => {
      this.hide()
    }, 4000)
  }
  
  hide() {
    this.element.style.animation = 'slide-out-right 0.3s ease-out forwards'
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
  
  close() {
    this.hide()
  }
}
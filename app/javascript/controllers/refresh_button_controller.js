// app/javascript/controllers/refresh_button_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "indicator", "icon"]
  
  connect() {
    // Добавляем обработчик клика только если кнопка существует
    if (this.hasButtonTarget) {
      this.buttonTarget.addEventListener('click', this.startLoading.bind(this))
    }
  }
  
  disconnect() {
    // Удаляем обработчик при размонтировании
    if (this.hasButtonTarget) {
      this.buttonTarget.removeEventListener('click', this.startLoading.bind(this))
    }
  }
  
  startLoading(event) {
    // Показываем индикатор загрузки
    if (this.hasIndicatorTarget) {
      this.indicatorTarget.classList.remove('hidden')
      this.indicatorTarget.classList.add('inline-flex')
    }
    
    // Делаем кнопку неактивной
    if (this.hasButtonTarget) {
      this.buttonTarget.classList.add('opacity-50', 'pointer-events-none')
    }
    
    // Анимируем иконку
    if (this.hasIconTarget) {
      this.iconTarget.classList.add('animate-spin')
    }
    
    // Сохраняем текст кнопки (опционально)
    if (this.hasButtonTarget && this.buttonTarget.textContent) {
      this.originalText = this.buttonTarget.textContent
      // Можно изменить текст кнопки (раскомментируйте если нужно)
      // this.buttonTarget.textContent = 'Загрузка...'
    }
  }
  
  // Метод для сброса состояния (если нужно)
  resetLoading() {
    if (this.hasIndicatorTarget) {
      this.indicatorTarget.classList.add('hidden')
      this.indicatorTarget.classList.remove('inline-flex')
    }
    
    if (this.hasButtonTarget) {
      this.buttonTarget.classList.remove('opacity-50', 'pointer-events-none')
      // Восстанавливаем текст (если меняли)
      if (this.originalText) {
        this.buttonTarget.textContent = this.originalText
      }
    }
    
    if (this.hasIconTarget) {
      this.iconTarget.classList.remove('animate-spin')
    }
  }
}
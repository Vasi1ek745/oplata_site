// app/javascript/controllers/payment_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submit(event) {
    const checkbox = event.currentTarget
    const form = checkbox.closest('form')
    const row = checkbox.closest('[data-payment-id]')
    const oplatumId = row.dataset.paymentId
    
    // Находим выбранный способ оплаты
    const selectedRadio = document.querySelector(`input[name="payment_${oplatumId}"]:checked`)
    const paymentDestination = selectedRadio ? selectedRadio.value : ''
    
    // Добавляем скрытое поле для способа оплаты
    let hiddenField = form.querySelector('input[name="oplatum[payment_destination]"]')
    if (!hiddenField) {
      hiddenField = document.createElement('input')
      hiddenField.type = 'hidden'
      hiddenField.name = 'oplatum[payment_destination]'
      form.appendChild(hiddenField)
    }
    hiddenField.value = paymentDestination
    
    // Отправляем форму
    form.requestSubmit()
  }
}
# app/models/oplatum.rb
class Oplatum < ApplicationRecord
  # ... existing code ...
    # Валидации
  validates :name, presence: { message: "не может быть пустым" }
  validates :date, presence: { message: "не может быть пустой" }
  
  # Опционально: валидация для canceled (чтобы был только 0 или 1)
def price(base_price = 1200)
  duration = self.duration.to_f
  duration = 1.0 if duration <= 0
  (base_price * duration).to_i
end
  def self.refresh_data_from_calendar
    Rails.logger.info "=== НАЧАЛО АВТОМАТИЧЕСКОГО ОБНОВЛЕНИЯ ==="
    
    # Ваш скрипт обновления
    script_path = Rails.root.join('calendar_module', 'add_events.rb')
    
    if File.exist?(script_path)
      result = system("ruby #{script_path}")
      if result
        Rails.logger.info "✅ Обновление успешно завершено в #{Time.current}"
      else
        Rails.logger.error "❌ Ошибка при обновлении в #{Time.current}"
      end
    else
      Rails.logger.error "❌ Скрипт не найден: #{script_path}"
    end
    
    Rails.logger.info "=== КОНЕЦ АВТОМАТИЧЕСКОГО ОБНОВЛЕНИЯ ==="
  end
end
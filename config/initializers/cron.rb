# config/initializers/cron.rb
if Rails.env.production? || Rails.env.development?
  Thread.new do
    loop do
      now = Time.current
      
      # Запуск в 23:00 каждый день
      if now.hour == 23 && now.min == 0
        Rails.logger.info "🕐 Запуск cron задачи в #{now}"
        
        begin
          Oplatum.refresh_data_from_calendar
        rescue => e
          Rails.logger.error "Ошибка в cron задаче: #{e.message}"
        end
        
        # Ждем 61 секунду, чтобы не запустить повторно
        sleep 61
      end
      
      sleep 30 # Проверяем каждые 30 секунд
    end
  end
end
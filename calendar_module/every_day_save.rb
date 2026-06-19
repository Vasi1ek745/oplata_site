require 'rufus-scheduler'

class Main
  module EveryDaySave
    def self.save
      # Создаем планировщик
      
       Thread.new do
      scheduler = Rufus::Scheduler.new

      # Запланируем задачу на ежедневное выполнение в 23:00
      scheduler.cron '0 23 * * *' do
        begin
          puts "[#{Time.now}] Начало выполнения задачи save_events..."
              DownloadFile.download_file
              events = ParserCalendar.today_events
              DataBase.check_events(events)
          puts "[#{Time.now}] Задача save_events успешно выполнена!"
        rescue => e
          puts "[#{Time.now}] Ошибка при выполнении save_events: #{e.message}"
          puts e.backtrace.join("\n")
        end
      end

      # Оставляем процесс активным
      scheduler.join
    end
  end
  end
end
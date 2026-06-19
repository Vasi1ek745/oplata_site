require 'icalendar'
require 'icalendar/recurrence'
require 'date'
require 'tzinfo'

module ParserCalendar
  def self.today_events
    ics_file_path = __dir__ + '/calendar/basic.ics'
    cal_file = File.open(ics_file_path)
    cals = Icalendar::Calendar.parse(cal_file)
    cal = cals.first

    today = Date.today
    timezone = TZInfo::Timezone.get('Asia/Yekaterinburg')

    today_events = []
    
    cal.events.each do |event|
      # Проверяем, попадает ли событие на сегодня
      event_date = event.dtstart.to_date
      next unless event_date == today
      
      # Получаем start_time и end_time
      start_time = timezone.utc_to_local(event.dtstart.to_time.utc)
      end_time = timezone.utc_to_local(event.dtend.to_time.utc)
      
      # Вычисляем длительность в часах
      duration_seconds = (end_time - start_time).to_f
      duration = (duration_seconds / 3600.0).round(1)
      
      # Если длительность получилась 0, пробуем альтернативный способ
      if duration == 0 && event.duration
        duration = (event.duration.to_i / 3600.0).round(1)
      end
      
      puts "📌 #{event.summary}: #{start_time} - #{end_time} => #{duration}ч"
      
      today_events << {
        summary: event.summary,
        start_time: start_time,
        end_time: end_time,
        duration: duration
      }
    end

    today_events
  end
end
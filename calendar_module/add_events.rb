require_relative '../config/environment'
require_relative 'download_calendar_file'
require_relative 'parser_ics_calendar'
require_relative 'check_events'

# Скачать файл календаря
puts "📥 Скачивание календаря..."
DownloadFile.download_file

# Выгрузить текущие события
puts "📖 Парсинг событий..."
events = ParserCalendar.today_events

# Добавить события, которых нет
puts "📊 Добавление новых событий..."
CheckEvents.check_events(events)

puts "✅ Готово! Добавлено/проверено: #{events.count} событий"
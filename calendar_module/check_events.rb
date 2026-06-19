module CheckEvents
  def self.check_events(events)
    added_count = 0
    skipped_count = 0

    events.each do |event|
      name = event[:summary].to_s
      date = event[:start_time].strftime("%e.%m.%y  #{day_of_week_russian(event)}")
      duration = event[:duration]

      existing = Oplatum.find_by(name: name, date: date)

      if existing
        skipped_count += 1
      else
        Oplatum.create(
          name: name,
          date: date,
          duration: duration
        )
        added_count += 1
        puts "✅ Добавлено: #{name} | #{date} | #{duration}ч"
      end
    end

    puts "📊 Итог:"
    puts "   ✅ Добавлено: #{added_count}"
    puts "   ⏭️  Пропущено (уже есть): #{skipped_count}"
  end

  def self.day_of_week_russian(event)
    days_of_week = ["Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота"]
    days_of_week[event[:start_time].strftime("%w").to_i]
  end
end
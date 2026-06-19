# test/integration/calendar_test.rb
require "test_helper"

class CalendarTest < ActionDispatch::IntegrationTest
  def setup
    # Подключаем модули перед каждым тестом
    require Rails.root.join("calendar_module", "download_calendar_file")
    require Rails.root.join("calendar_module", "parser_ics_calendar")
    require Rails.root.join("calendar_module", "check_events")
  end

  test "download_calendar_file works" do
    result = DownloadFile.download_file
    assert result
    assert File.exist?(Rails.root.join("calendar_module", "calendar", "basic.ics"))
  end

  test "parser extracts events" do
    DownloadFile.download_file
    events = ParserCalendar.today_events
    assert events.is_a?(Array)
    
    if events.any?
      event = events.first
      assert event[:summary].present?
      assert event[:start_time].present?
      assert event[:end_time].present?
      assert event[:duration].present?
    end
  end

  test "check_events adds new events" do
    events = [
      {
        summary: "Тест календаря",
        start_time: Time.current,
        end_time: Time.current + 1.hour,
        duration: 1.0
      }
    ]
    
    assert_difference('Oplatum.count', 1) do
      CheckEvents.check_events(events)
    end
  end

  test "check_events skips existing events" do
    date_formatted = Date.today.strftime("%e.%m.%y  #{CheckEvents.day_of_week_russian({start_time: Time.current})}")
    
    Oplatum.create(
      name: "Существующее событие",
      date: date_formatted,
      duration: 1.0,
      pay: false,
      canceled: false
    )
    
    events = [
      {
        summary: "Существующее событие",
        start_time: Time.current,
        end_time: Time.current + 1.hour,
        duration: 1.0
      }
    ]
    
    assert_no_difference('Oplatum.count') do
      CheckEvents.check_events(events)
    end
  end
end
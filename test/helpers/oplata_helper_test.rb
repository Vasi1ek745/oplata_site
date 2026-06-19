require "test_helper"

class OplataHelperTest < ActionView::TestCase
  test "format_duration formats 1 hour" do
    assert_equal "1 час", format_duration(1)
  end

  test "format_duration formats 1.5 hours" do
    assert_equal "1.5 часа", format_duration(1.5)
  end

  test "format_duration formats 2 hours" do
    assert_equal "2 часа", format_duration(2)
  end

  test "format_duration handles nil" do
    assert_equal "—", format_duration(nil)
  end

  test "format_duration handles empty string" do
    assert_equal "—", format_duration("")
  end

  test "format_duration handles unknown values" do
    assert_equal "2.5", format_duration(2.5)
  end
end
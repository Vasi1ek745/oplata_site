require "test_helper"

class OplatumTest < ActiveSupport::TestCase
  def setup
    @oplatum = Oplatum.new(
      name: "Тестовое занятие",
      date: Date.today,
      duration: 1.5,
      pay: false,
      canceled: false,
      payment_destination: nil
    )
  end

  test "should be valid with valid attributes" do
    assert @oplatum.valid?
  end

  test "should require name" do
    @oplatum.name = nil
    assert_not @oplatum.valid?
    assert_includes @oplatum.errors[:name], "не может быть пустым"
  end

  test "should require date" do
    @oplatum.date = nil
    assert_not @oplatum.valid?
    assert_includes @oplatum.errors[:date], "не может быть пустой"
  end

  test "should accept valid payment destinations" do
    valid_destinations = ["Т-Банк", "Анна Озон", "Мама Озон"]
    valid_destinations.each do |dest|
      @oplatum.payment_destination = dest
      assert @oplatum.valid?
    end
  end

  test "should accept empty payment destination" do
    @oplatum.payment_destination = nil
    assert @oplatum.valid?
  end

  test "should have default pay as false" do
    oplatum = Oplatum.new(name: "Тест", date: Date.today)
    assert_equal false, oplatum.pay
  end

  test "should have default canceled as false" do
    oplatum = Oplatum.new(name: "Тест", date: Date.today)
    assert_equal false, oplatum.canceled
  end

  test "should calculate price based on duration" do
    base_price = 1200
    
    oplatum_1h = Oplatum.new(duration: 1.0)
    assert_equal 1200, oplatum_1h.price(base_price)
    
    oplatum_1_5h = Oplatum.new(duration: 1.5)
    assert_equal 1800, oplatum_1_5h.price(base_price)
    
    oplatum_2h = Oplatum.new(duration: 2.0)
    assert_equal 2400, oplatum_2h.price(base_price)
  end
end
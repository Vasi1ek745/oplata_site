require "test_helper"

class DashboardServiceTest < ActiveSupport::TestCase
  def setup
    @start_date = Date.today.beginning_of_month
    @end_date = Date.today.end_of_month
    
    # Создаем тестовые данные
    Oplatum.create(
      name: "Занятие 1",
      date: Date.today,
      duration: 1.0,
      pay: true,
      payment_destination: "Т-Банк"
    )
    Oplatum.create(
      name: "Занятие 2",
      date: Date.today,
      duration: 1.5,
      pay: true,
      payment_destination: "Анна Озон"
    )
    Oplatum.create(
      name: "Занятие 3",
      date: Date.today,
      duration: 2.0,
      pay: false,
      canceled: false
    )
    Oplatum.create(
      name: "Занятие 4",
      date: Date.today,
      duration: 1.0,
      pay: false,
      canceled: true
    )
  end

  test "calculates total lessons correctly" do
    service = DashboardService.new(@start_date, @end_date)
    result = service.call
    
    assert_equal 4, result[:total_lessons]
  end

  test "calculates paid count correctly" do
    service = DashboardService.new(@start_date, @end_date)
    result = service.call
    
    assert_equal 2, result[:paid_count]
  end

  test "calculates unpaid count correctly" do
    service = DashboardService.new(@start_date, @end_date)
    result = service.call
    
    assert_equal 1, result[:unpaid_count]
  end

  test "calculates canceled count correctly" do
    service = DashboardService.new(@start_date, @end_date)
    result = service.call
    
    assert_equal 1, result[:canceled_count]
  end

  test "calculates total income correctly" do
    service = DashboardService.new(@start_date, @end_date)
    result = service.call
    
    # Занятие 1: 1200, Занятие 2: 1800
    assert_equal 3000, result[:total_income]
  end

  test "calculates total debt correctly" do
    service = DashboardService.new(@start_date, @end_date)
    result = service.call
    
    # Занятие 3: 2400
    assert_equal 2400, result[:total_debt]
  end

  test "calculates payment percentage correctly" do
    service = DashboardService.new(@start_date, @end_date)
    result = service.call
    
    # 2 оплачено из 4 активных (отмененное не считается)
    assert_equal 66.7, result[:payment_percentage]
  end

  test "calculates payment methods correctly" do
    service = DashboardService.new(@start_date, @end_date)
    result = service.call
    
    assert_equal 1, result[:payment_methods]["Т-Банк"][:count]
    assert_equal 1, result[:payment_methods]["Анна Озон"][:count]
    assert_equal 0, result[:payment_methods]["Мама Озон"][:count]
  end

  test "returns recent payments" do
    service = DashboardService.new(@start_date, @end_date)
    result = service.call
    
    assert_equal 2, result[:recent_payments].count
  end
end
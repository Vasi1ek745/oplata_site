# app/services/dashboard_service.rb
class DashboardService
  attr_reader :base_price, :start_date, :end_date

  def initialize(start_date, end_date, base_price = 1200)
    @start_date = start_date
    @end_date = end_date
    @base_price = base_price
  end

  def call
    {
      total_lessons: total_lessons,
      paid_count: paid_count,
      unpaid_count: unpaid_count,
      canceled_count: canceled_count,
      total_income: total_income,
      total_debt: total_debt,
      payment_percentage: payment_percentage,
      payment_methods: payment_methods,
      recent_payments: recent_payments,
      payments_by_day: payments_by_day,
      current_month: current_month,
      selected_month: selected_month
    }
  end

  private

  def all_lessons
    @all_lessons ||= Oplatum.where("date >= ? AND date <= ?", @start_date, @end_date)
  end

  def paid_lessons
    @paid_lessons ||= all_lessons.where(pay: true, canceled: false)
  end

  def unpaid_lessons
    @unpaid_lessons ||= all_lessons.where(pay: false, canceled: false)
  end

  def canceled_lessons
    @canceled_lessons ||= all_lessons.where(canceled: true)
  end

  def total_lessons
    all_lessons.count
  end

  def paid_count
    paid_lessons.count
  end

  def unpaid_count
    unpaid_lessons.count
  end

  def canceled_count
    canceled_lessons.count
  end

  def total_income
    paid_lessons.sum { |lesson| calculate_price(lesson) }
  end

  def total_debt
    unpaid_lessons.sum { |lesson| calculate_price(lesson) }
  end

def payment_percentage
  total_active = all_lessons.where(canceled: false).count
  total_active > 0 ? (paid_count.to_f / total_active * 100).round(1) : 0
end

  def calculate_price(lesson)
    duration = lesson.duration.to_f
    duration = 1.0 if duration <= 0
    @base_price * duration
  end

  def payment_methods
    methods = {}
    
    ['Т-Банк', 'Анна Озон', 'Мама Озон'].each do |method|
      lessons = paid_lessons.where(payment_destination: method)
      methods[method] = {
        count: lessons.count,
        sum: lessons.sum { |lesson| calculate_price(lesson) }
      }
    end
    
    methods
  end

 def recent_payments
  paid_lessons.order(updated_at: :desc).limit(5)
end

  def payments_by_day
    paid_lessons.group_by { |p| p.updated_at.to_date }
                .transform_values(&:count)
                .sort
                .to_h
  end

  def current_month
    @start_date.strftime("%B %Y")
  end

  def selected_month
    @start_date.strftime("%Y-%m-%d")
  end
end
class OplataController < ApplicationController
  before_action :set_oplatum, only: %i[ show edit update destroy ]

  def index
    @oplata = Oplatum.all
    @unpaid_not_canceled = @oplata.reject { |o| o.pay || o.canceled }
  end

  # Новая страница: недавно оплаченные
  def recently_paid
    # Получаем последние 10 оплаченных записей (не отмененных)
    @recently_paid = Oplatum.where(pay: true, canceled: false)
                            .order(updated_at: :desc)
                            .limit(10)
  end

  def show
  end

  def new
    @oplatum = Oplatum.new
  end

  def edit
  end

def create
  @oplatum = Oplatum.new(oplatum_params)
  @oplatum.canceled = 0

  respond_to do |format|
    if @oplatum.save
      format.html { redirect_to oplata_path, notice: "Платёж успешно создан" }
      format.json { render :show, status: :created, location: @oplatum }
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @oplatum.errors, status: :unprocessable_entity }
    end
  end
end


def update
  if @oplatum.update(oplatum_params)
    respond_to do |format|
      format.html { redirect_to oplata_path, notice: "Платёж успешно обновлён" }
      format.turbo_stream do
        if @oplatum.pay == true || @oplatum.canceled == true
          render turbo_stream: turbo_stream.remove(@oplatum)
        else
          render turbo_stream: turbo_stream.replace(@oplatum, 
            partial: "oplata/oplatum_row", 
            locals: { oplatum: @oplatum }
          )
        end
      end
    end
  else
    render :edit, status: :unprocessable_entity
  end
end

  def destroy
    @oplatum.destroy!

    respond_to do |format|
      format.html { redirect_to oplata_path, notice: "Oplatum was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def refresh_data
    script_path = Rails.root.join('calendar_module', 'add_events.rb')
    
    result = system("ruby #{script_path}")
    
    if result
      redirect_to oplata_path, notice: "Данные успешно обновлены"
    else
      redirect_to oplata_path, alert: "Ошибка при обновлении данных"
    end
  end

  def manual_refresh
    Oplatum.refresh_data_from_calendar
    redirect_to oplata_path, notice: "Принудительное обновление выполнено в #{Time.current}"
  end
# app/controllers/oplata_controller.rb
   
def dashboard
  @title = "Дашборд"
  
  # Получаем месяц из параметров (по умолчанию текущий)
  if params[:month].present?
    @selected_month = Date.parse(params[:month])
  else
    @selected_month = Date.today
  end
  
  start_of_month = @selected_month.beginning_of_month
  end_of_month = @selected_month.end_of_month
  
  # Передаем start_date и end_date в сервис
  @dashboard = DashboardService.new(start_of_month, end_of_month).call
end




  private

  def set_oplatum
    @oplatum = Oplatum.find(params.expect(:id))
  end

  def oplatum_params
      params.expect(oplatum: [ :name, :date, :pay, :canceled, :duration, :payment_destination ])
  end
end
# app/controllers/pdf_create_controller.rb
class PdfCreateController < ApplicationController
  def index
    @title = "PDF Create"
  end

  def generate
    exam_type = params[:exam]
    part = params[:part]
    task_number = params[:task_number]
    
    begin
      # Подключаем скрипт из папки pdf_create_module
      require Rails.root.join('pdf_create_module', 'pdf_generator')
      
      # Создаем экземпляр генератора
      generator = PdfGenerator.new
      
      # Генерируем PDF в зависимости от типа
      if part == "single_task" && task_number.present?
        # Генерация PDF для конкретного номера задания
        file_path = generator.generate_single_task(exam_type, task_number.to_i)
      else
        # Обычная генерация варианта
        file_path = generator.generate(exam_type, part)
      end
      
      # Проверяем, что файл существует
      if File.exist?(file_path)
        send_file file_path,
                  type: 'application/pdf',
                  disposition: 'inline',
                  filename: File.basename(file_path)
      else
        redirect_to pdf_create_path, alert: "Файл не найден после генерации"
      end
      
    rescue => e
      Rails.logger.error "Ошибка генерации PDF: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      redirect_to pdf_create_path, alert: "Ошибка генерации: #{e.message}"
    end
  end
  
  # Опционально: очистка старых файлов
  def cleanup
    require Rails.root.join('pdf_create_module', 'pdf_generator')
    generator = PdfGenerator.new
    deleted = generator.cleanup_old_files(20)
    redirect_to pdf_create_path, notice: "Удалено #{deleted} старых файлов"
  end
end
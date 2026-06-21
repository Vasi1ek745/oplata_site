# pdf_create_module/pdf_generator.rb
require "prawn"
require "fileutils"

class PdfGenerator
def initialize
  @root_path = Rails.root || Pathname.new(File.expand_path('../..', __FILE__))
  
  # ✅ ПРОВЕРЯЕМ ПУТИ В ПРАВИЛЬНОМ ПОРЯДКЕ
  server_path = "/home/vasiliy/images"
  local_path = "/home/vasiliy/Изображения/Новая папка"
  
  if Dir.exist?(server_path)
    @image_path = server_path
    Rails.logger.info "✅ Сервер: используем #{@image_path}"
  elsif Dir.exist?(local_path)
    @image_path = local_path
    Rails.logger.info "✅ Локально: используем #{@image_path}"
  else
    @image_path = @root_path.join('public', 'images').to_s
    Rails.logger.warn "❌ Папка не найдена! Использую: #{@image_path}"
  end
  
  Rails.logger.info "📂 Путь к изображениям: #{@image_path}"
  
  @font_path = @root_path.join('pdf_create_module', 'fonts')
  @output_path = @root_path.join('pdf_create_module', 'pdf')
  FileUtils.mkdir_p(@output_path)
end

  # Генерация PDF с параметрами
  def generate(exam_type, part)
    case exam_type
    when "math_ege"
      generate_math_ege(part)
    else
      raise "Неизвестный тип экзамена: #{exam_type}"
    end
  end

  # Генерация PDF для конкретного номера задания (все варианты заданий с этим номером)
  def generate_single_task(exam_type, task_number)
    case exam_type
    when "math_ege"
      title = "Математика ЕГЭ - Задание №#{task_number}"
    else
      raise "Неизвестный тип экзамена: #{exam_type}"
    end
    
    timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
    filename = "#{exam_type}_task_#{task_number}_#{timestamp}.pdf"
    file_path = @output_path.join(filename)
    
    images = select_all_images_for_task(task_number)
    
    if images.empty?
      raise "Не найдено изображений для задания №#{task_number}"
    end
    
    Prawn::Document.generate(file_path.to_s) do |pdf|
      setup_fonts(pdf)
      
      pdf.text title, style: :bold, size: 16, align: :center
      pdf.move_down 20
      
      images.each_with_index do |image_path, index|
        # Проверяем, помещается ли изображение на текущей странице
        # Вычисляем примерную высоту изображения (ширина 500, сохраняем пропорции)
        image_height = 0
        if image_path && File.exist?(image_path)
          begin
            temp_image = MiniMagick::Image.open(image_path)
            original_width = temp_image.width
            original_height = temp_image.height
            image_height = (original_height.to_f / original_width.to_f) * 450
          rescue
            image_height = 100 # значение по умолчанию, если MiniMagick не установлен
          end
        else
          image_height = 50
        end
        
        total_height = image_height + 30 # изображение + отступы и номер
        
        # Если не хватает места, создаем новую страницу
        if pdf.y < total_height + 50
          pdf.start_new_page
          pdf.text title, style: :bold, size: 16, align: :center
          pdf.move_down 20
        end
        
        # Номер задания
        pdf.text_box "#{index + 1}.", 
                     at: [0, pdf.y], 
                     width: 30, 
                     size: 12,
                     style: :bold
        
        # Вставляем изображение
        if image_path && File.exist?(image_path)
          pdf.image image_path, 
                    at: [35, pdf.y], 
                    width: 450
        else
          pdf.text_box "[Изображение не найдено]", 
                       at: [35, pdf.y - 10], 
                       width: pdf.bounds.width - 45,
                       size: 10,
                       color: "FF0000"
        end
        
        # Перемещаемся вниз на реальную высоту изображения + отступ
        pdf.move_down image_height + 15
      end
    end
    
    file_path.to_s
  end

  private

  def generate_math_ege(part)
    case part
    when "first_part"
      generate_variant("math_ege_first", 1..12, "Математика ЕГЭ - Первая часть")
    when "full_variant"
      generate_variant("math_ege_full", 1..19, "Математика ЕГЭ - Полный вариант")
    end
  end

  def generate_variant(filename_prefix, task_numbers, title)
    timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
    filename = "#{filename_prefix}_#{timestamp}.pdf"
    file_path = @output_path.join(filename)
    
    images = select_random_images(task_numbers)
    
    Prawn::Document.generate(file_path.to_s) do |pdf|
      setup_fonts(pdf)
      
      pdf.text title, style: :bold, size: 16, align: :center
      pdf.move_down 20
      
      images.each_with_index do |image_path, index|
        task_number = task_numbers.to_a[index]
        
        # Вычисляем высоту изображения
        image_height = 0
        if image_path && File.exist?(image_path)
          begin
            temp_image = MiniMagick::Image.open(image_path)
            original_width = temp_image.width
            original_height = temp_image.height
            image_height = (original_height.to_f / original_width.to_f) * 450
          rescue
            image_height = 100
          end
        else
          image_height = 50
        end
        
        total_height = image_height + 30
        
        # Если не хватает места, создаем новую страницу
        if pdf.y < total_height + 50
          pdf.start_new_page
          pdf.text title, style: :bold, size: 16, align: :center
          pdf.move_down 20
        end
        
        # Номер задания
        pdf.text_box "#{task_number}.", 
                     at: [0, pdf.y], 
                     width: 30, 
                     size: 12,
                     style: :bold
        
        if image_path && File.exist?(image_path)
          pdf.image image_path, 
                    at: [35, pdf.y], 
                    width: 450
        else
          pdf.text_box "[Изображение не найдено]", 
                       at: [35, pdf.y - 10], 
                       width: pdf.bounds.width - 45,
                       size: 10,
                       color: "FF0000"
        end
        
        pdf.move_down image_height + 15
      end
    end
    
    file_path.to_s
  end

  def setup_fonts(pdf)
    arial_normal = @font_path.join('ARIAL.TTF')
    arial_bold = @font_path.join('ARIALBD.TTF')
    
    if File.exist?(arial_normal.to_s)
      pdf.font_families.update("Arial" => {
        normal: arial_normal.to_s,
        bold: arial_bold.to_s
      })
      pdf.font "Arial"
    else
      Rails.logger.warn "Шрифты Arial не найдены в #{@font_path}"
    end
  end

  def select_random_images(task_numbers)
    images = []
    
    task_numbers.each do |number|
      pattern = File.join(@image_path, "#{number};*")
      files = Dir.glob(pattern).select { |f| f =~ /\.(png|jpg|jpeg|gif)$/i }
      
      if files.any?
        images << files.sample
        Rails.logger.debug "Выбрано изображение для задания #{number}: #{File.basename(images.last)}"
      else
        Rails.logger.warn "Не найдено изображение для задания #{number} в #{@image_path}"
        images << nil
      end
    end
    
    images
  end

  def select_all_images_for_task(task_number)
    images = []
    pattern = File.join(@image_path, "#{task_number};*")
    
    Dir.glob(pattern).each do |file|
      if file =~ /\.(png|jpg|jpeg|gif)$/i
        images << file
      end
    end
    
    # Сортируем по имени файла (по идентификатору)
    images.sort!
    
    Rails.logger.info "Найдено изображений для задания #{task_number}: #{images.size}"
    images
  end

  def cleanup_old_files(keep_count = 10)
    files = Dir.glob(@output_path.join('*.pdf').to_s).sort_by { |f| File.mtime(f) }.reverse
    files_to_delete = files[keep_count..-1]
    
    files_to_delete&.each do |file|
      File.delete(file)
      Rails.logger.debug "Удален старый PDF: #{File.basename(file)}"
    end
    
    files_to_delete&.size || 0
  end
end
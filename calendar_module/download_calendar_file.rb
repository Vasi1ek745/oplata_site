require 'faraday'
require 'fileutils'


  module DownloadFile

    def self.download_file
      url = 'https://calendar.google.com/calendar/ical/vasi1ek745%40gmail.com/private-f493c6710447940b6762e5467f4b81b2/basic.ics'
      save_directory = '/home/vasiliy/RailsProgekt/oplata_site/calendar_module/calendar/'
      
      # Определяем имя файла (если не задано - берем из URL)
      filename ||= File.basename(URI.parse(url).path)

      # Полный путь для сохранения
    
      save_path = File.join(save_directory, filename)
      conn = Faraday.new(url: url, proxy: nil)
      response = conn.get
      # Сохраняем файл
      File.binwrite(save_path, response.body)
    end
  
      
  end

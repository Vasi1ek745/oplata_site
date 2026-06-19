# app/helpers/oplata_helper.rb
module OplataHelper
  def format_duration(duration)
    return "—" if duration.blank?
    
    duration = duration.to_f
    case duration
    when 1
      "1 час"
    when 1.5
      "1.5 часа"
    when 2
      "2 часа"
    else
      duration.to_s
    end
  end
end
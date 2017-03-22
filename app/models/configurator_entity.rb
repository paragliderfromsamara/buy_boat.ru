class ConfiguratorEntity < Configurator
  belongs_to :boat_type
  belongs_to :boat_option_type, optional: true, validate: false
  
  def self.default_scope
    order("arr_id ASC")
  end
  
  def self.parse_options_in_html(file_data) #парсит файл формируемый старым конфигуратором 
    return [] if file_data.blank?
    doc = Nokogiri::HTML(file_data, nil, 'utf-8')
    v = []
    doc.css('table tr').each do |table|
        if !table[:id].blank?
          v.push({param_code: table[:id], amount: table.css('td').last.children.to_s.scan(/\d+/).join.to_i})
        end
    end
    return v
  end
  
  def self.find_standart_from_array(arr) #достаем выбраный стандарт из массива
    return nil if arr.blank?
    arr.each do |e|
      standart_in_ot = BoatOptionType.find_by(param_code: e[:param_code])
      next if standart_in_ot.nil?
      return standart_in_ot if standart_in_ot.is_standart?
    end
    return nil
  end
  
end

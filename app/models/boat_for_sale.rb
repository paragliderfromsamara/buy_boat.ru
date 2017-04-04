class BoatForSale < Configurator
  attr_accessor :option_list_file

  belongs_to :boat_type
  has_many :selected_options, dependent: :delete_all
  
  after_save :check_build_code
  
  accepts_nested_attributes_for :selected_options
  
  def selected_options_attributes=(attrs)
    return if attrs.blank?
    self.selected_options.create(attrs.values)
    calculate_amount #пересчёт полной стоимости
  end
  
  def selected_options_for_show
      selected_options.includes(:boat_option_type).map {|opt| {arr_id: opt.arr_id, name: opt.boat_option_type.nil? ? opt.param_name : opt.boat_option_type.name, name: opt.boat_option_type.nil? ? opt.param_name : opt.boat_option_type.name, amount: opt.amount, rec_type: opt.rec_type, rec_level: opt.rec_level}}
  end
  
  #Извлекаем данные из файла и делаем вывод о его годности 
  #возвращаемые данные 
  # 1.) {status: 1, message: "Файл не выбран"} - если загруженный файл пуст или забыли подгрузить
  # 2.) {status: 2, message: "В загруженном файле нет данных"} - если файл не пуст, но данные в нем отсуствуют
  # 3.) {status: 3, message: "В загруженном файле не указан стандарт типа лодки, либо указанный стандарт не добавлен на сайт"}  - если среди извлеченных опций не нашлось стандарта
  # 4.) {status: 4, message: "Файл не содержит ни одного существующего в БД элемента"} - если ни один элемент не существует в Базе данных
  # 5.) {status: 5, message: "Некоторые из добавленных элементов отсутствуют"} - если некоторые элементы отсутствуют на сайте
  # 6.) {status: 6, message: "Импортируемые данные готовы к сохранению"} - если вопросов нет и все хорошо
  def self.parse_file(parser_data)
    return {status: 1, message: "Не было получено никаких данных"} if parser_data.blank?
    b_type = BoatType.find_by(id: parser_data[:boat_type_id])
    return {status: 2, message: "Тип лодки не найден, либо не указан"} if b_type.nil?
    return {status: 3, message: "Файл не выбран"} if parser_data[:option_list_file].blank?
    parsed_data = ConfiguratorEntity.parse_options_in_html(parser_data[:option_list_file]) #поиск распознаваемых данных в загруженном файле
    return {status: 4, message: "В загруженном файле нет данных"} if parsed_data.blank?
    imported_std = ConfiguratorEntity.find_standart_from_array(parsed_data) #поиск в импортированном файле стандарта лодки
    return {status: 5, message: "В загруженном файле не указан стандарт типа лодки, либо указанный стандарт не добавлен на сайт", data: parsed_data} if imported_std.nil?
    return {status: 6, message: "#{b_type.catalog_name} не содержит стандарта '#{imported_std.name}'", data: parsed_data} if b_type.configurator_entities.find_by(boat_option_type_id: imported_std.id).nil?
    groups = []                    #группы
    found_els = []                 #найденные элементы
    undefined_on_site = []         #элементы отсутствующие в BoatOptionTypes
    undefined_on_configurator = [] #элементы не добавленные в конфигуратор
    idx = 0
    parsed_data.each do |d|
      cur_group = nil
      cur_step = nil
      cur_lvl = 0
      is_exists = false
      b_type.configurator_entities.each do |e|
        lvl = e.rec_level.to_i
        cur_lvl = lvl if cur_lvl != lvl
        cur_group = {arr_id: e.arr_id, rec_type: e.rec_type, param_name: e.param_name, rec_level: e.rec_level, amount: 0} if e.is_group? && cur_lvl > 1
        cur_step = {arr_id: e.arr_id, rec_type: e.rec_type, param_name: e.param_name, rec_level: e.rec_level, amount: 0}  if e.is_group? && cur_lvl == 1
        if e.param_code == d[:param_code]
          if !cur_step.nil?
            found_els.push(cur_step) if found_els.index(cur_step).nil?
            cur_step = nil
          end
          if !cur_group.nil? 
            found_els.push(cur_group) if found_els.index(cur_group) == nil && cur_group[:rec_level].to_i < e.rec_level.to_i 
            cur_group = nil
          end
          d[:boat_option_type_id] = e.boat_option_type_id
          d[:arr_id] = e.arr_id
          d[:rec_level] = e.rec_level
          d[:rec_type] = e.rec_type
          found_els.push({arr_id: e.arr_id, rec_type: e.rec_type, rec_level: e.rec_level, amount: d[:amount], boat_option_type_id: e.boat_option_type_id})
          is_exists = true
          break 
        end
      end
      if !is_exists
        opt_type = BoatOptionType.find_by(param_code: d[:param_code] )
        if opt_type.nil?
          d[:message] =  "Не найден в файле конфигуратор и в типах опций"
          d[:param_name] = "Не найдено"
          undefined_on_site.push(d)
        else
          d[:message] =  "Не найден в файле конфигуратора"
          d[:param_name] = opt_type.name
          undefined_on_configurator.push(d)
        end
      end
    end
    v = {
          not_found_on_site: undefined_on_site, 
          not_found_on_configurator: undefined_on_site, 
          found: found_els, 
          file: parser_data[:option_list_file],
          boat_type_id: b_type.id
        }
    if found_els.blank?
      v[:status] = 7
      v[:message] = "Файл не содержит ни одного существующего в БД элемента"
    elsif !undefined_on_site.blank? || !undefined_on_configurator.blank?
      v[:status] = 8
      v[:message] = "Некоторые из добавленных элементов отсутствуют"
    else
      v[:status] = 9
      v[:message] = "Импортируемые данные готовы к сохранению"
    end
    return v
  end
  
    
  def add_file_to_tmp
    if new_record?
      tmp_folder = getTmpFolderName
      save_dir = "public/#{tmp_folder}"
      uploaded_io = self.option_list_file
      FileUtils.mkdir_p(save_dir) unless File.exists?("#{Rails.root}/#{save_dir}")
 		  File.open(Rails.root.join(save_dir, uploaded_io.original_filename), 'wb') do |file|
 			  file.write(uploaded_io.read)
 		  end
      dir_link = "/#{tmp_folder}/" + uploaded_io.original_filename
      self.size = uploaded_io.size
      self.name = uploaded_io.original_filename
      self.link = dir_link
    end
  end
  
  def standart 
    self.selected_options.where(rec_type: Configurator.rec_type_standart).first
  end
  
  def catalog_name
    self.boat_type.catalog_name
  end 
  
  private
  
  def check_build_code
    opts = self.selected_options.where.not(boat_option_type_id: nil).select(:boat_option_type_id)
    v = !opts.blank? ? Digest::SHA2.hexdigest(%{#{opts.to_a.map{|v| v.boat_option_type_id}.join('-')}--#{self.boat_type_id}}) : ""
    self.update_attribute(:build_code, v) if self.build_code != v
  end
  
  def calculate_amount
    self.amount = self.selected_options.blank? ? 0 : self.selected_options.sum(:amount)
  end
  
  def file_path
    {
      folder: "configurator/option_combinations",
      file: "option_combination_#{self.id}.html"  
    }
  end
   
  def check_file
    
  end
  
end
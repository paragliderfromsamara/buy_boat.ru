class BoatType < ApplicationRecord
  attr_accessor :copy_params_table_from_id
  after_create :make_boat_parameter_values
  
  belongs_to :creator, class_name: "User" #кто создал
  belongs_to :modifier, class_name: "User" #кто изменил
  
  has_many :boat_type_modifications, dependent: :destroy
  
  has_many :entity_property_values, as: :entity, dependent: :delete_all
  accepts_nested_attributes_for :entity_property_values
  
  has_many :boat_photos, dependent: :destroy
  has_many :photos, through: :boat_photos
  #belongs_to :photo
  
  belongs_to :boat_series, optional: true, validate: false
  belongs_to :trademark
  
  
  has_many :boat_for_sales, dependent: :destroy
  
  
  accepts_nested_attributes_for :photos
  
  has_many :configurator_entities, dependent: :destroy
  accepts_nested_attributes_for :configurator_entities

  
  def self.property_types
    PropertyType.all.joins(:boat_property_type).select(
                                                      "
                                                        property_types.ru_name AS ru_name,
                                                        property_types.com_name AS com_name,
                                                        property_types.ru_measure AS ru_measure,
                                                        property_types.com_measure AS com_measure,
                                                        property_types.ru_short_name AS ru_short_name,
                                                        property_types.com_short_name AS com_short_name,
                                                        property_types.tag AS tag,
                                                        property_types.value_type AS value_type,
                                                        boat_property_types.property_type_id AS id,
                                                        boat_property_types.order_number AS order_number
                                                      "
                                                    ).order("boat_property_types.order_number ASC")
  end
  
  def property_values(locale = "ru")
    entity_property_values.includes(property_type: :boat_property_type).order("boat_property_types.order_number ASC").to_a.map {|epv| {
      id: epv.id,
      name: epv.property_type["#{locale}_name".to_sym],
      short_name: epv.property_type["#{locale}_short_name".to_sym],
      measure: epv.property_type["#{locale}_measure".to_sym],
      value: epv.get_value,
      is_binded: epv.is_binded, 
      order_number: epv.property_type.boat_property_type.nil? ? 0 : epv.property_type.boat_property_type.order_number
     }
    }
  end
  

  
  def length
    bpt = get_property_values_by_tags("max_length").first
    return 0 if bpt.nil?
    return bpt.get_value
  end
  
  def horse_power_range
    bpts = get_property_values_by_tags(["min_hp", "max_hp"])
    min = 0
    max = 0
    bpts.each do |bpt|
      min = bpt.get_value if bpt.property_type.tag == "min_hp"
      max = bpt.get_value if bpt.property_type.tag == "max_hp"  
    end 
    return {max: max, min: min}
  end
  
  def alter_photo
    photos.first
  end
  
  def photos_hash_view(is_wide=false)
    return "" if photos.blank?
    photos.map {|ph| ph.hash_view(is_wide)}
  end
  
  def self.show_page_scope
    joins(:trademark).includes(:photos)#.active
  end 
  
  def self.with_bfs
    active.includes(:boat_for_sales)
  end
  
  def self.admin
    all
  end
  
  def self.active #лодки которые показываются в каталоге
    where(is_deprecated: false, is_active: true)
  end
  
  def self.not_active  #лодки которые по каким-то причинам не показаны в каталоге, к примеру
    where(is_deprecated: false, is_active: false)
  end
  
  def self.deprecated  #устаревшие
    where(is_deprecated: true)
  end
  
  def entity_property_values_attributes=(attrs)
    return if attrs.blank?
    to_add = []
    attrs.values.each do |v|
      pv = self.entity_property_values.find_by(property_type_id: v[:property_type_id])
      if pv.nil?
        to_add.push v
      else
        pv.update_attributes(v)
      end
    end
    self.entity_property_values.create(to_add) if !to_add.blank?
  end
  
  def photos_attributes=(attrs)
    if !attrs.blank?
      self.photos.create(attrs)
      #attrs.each {|ph| self.photos.create(link: ph[:link], uploader_id: self.modifier_id)}
    end
  end
  
  def configurator_entities_attributes=(attrs)
    if !attrs.blank?
      self.configurator_entities.delete_all
      self.reload
      attrs.values.each do |a|
        if !a[:param_code].blank?
          option_type = BoatOptionType.find_by(param_code: a[:param_code])
          option_type = BoatOptionType.create(name: a[:param_name], param_code: a[:param_code], rec_type: a[:rec_type], amount: a[:price], description: a[:comment]) if option_type.nil?
          a[:boat_option_type_id] = option_type.id
        end
      end  
      self.configurator_entities.create(attrs.values)
      self.reload
      self.check_modifications #ищем в загруженном файле стандарты и вносим их в список модификаций
      #attrs.each {|a| self.configurator_entities.create(attrs.values)}
      #attrs.each {|ph| self.photos.create(link: ph[:link], uploader_id: self.modifier_id)}
    end
  end
  
  def remote_cnf_file_exists?
    return false if self.cnf_data_file_url.blank?
    uri = URI(self.cnf_data_file_url)
    request = Net::HTTP.new uri.host
    response= request.request_head uri.path
    return response.code.to_i == 200
  end
  
  def local_cnf_file_exists?
    File.exists?("#{Rails.root}/#{save_dir}")
  end
  
  def create_local_cnf_file
    return if !remote_cnf_file_exists?
    save_dir = "public/#{cnf_folder_name}"
    uri = URI(self.cnf_data_file_url)
    uploaded_io = Net::HTTP.get(uri)
    FileUtils.mkdir_p(save_dir) unless File.exists?("#{Rails.root}/#{save_dir}")
  	File.open(Rails.root.join(save_dir, cnf_file_name), 'wb') do |file|
  		  file.write(uploaded_io)
  	end
  end
  
  def need_update_local_file?
    return false if !remote_cnf_file_exists?
    return true if remote_cnf_file_exists? && !File.exists?("#{Rails.root}/public/#{cnf_folder_name}/#{cnf_file_name}")
    uri = URI(self.cnf_data_file_url)
    remote = Net::HTTP.get(uri)
    dir = "public/#{cnf_folder_name}"
    file = File.open(Rails.root.join(Rails.root.join(dir, cnf_file_name)), 'r') do |f|
      return (f == remote)
    end
  end
  
  #подготавливает тип лодки для отрисовки React.js, в boat_types/show
  def hash_view(locale = "ru")
    {
      id: self.id,
      trademark: self.trademark.hash_view,
      modifications: self.boat_type_modifications.map{|mdf| mdf.hash_view},
      name: self.catalog_name,
      description: self.description,
      photo: self.photos_hash_view(true).first, 
      parameters: self.property_values(locale), #self.boat_parameters_for_react,
      photos: self.photos_hash_view,
      boat_for_sales: BoatForSale.filtered_collection(self.boat_for_sales.ids)#.select(:id, :amount)#.includes(:selected_options).map {|bfs| {id: bfs.id, selectedOptions: bfs.selected_options_for_show}} #.with_selected_options
    }
  end
  
  def catalog_name #название типа лодки с наименованием производителя, серией и типом корпуса
    %{#{self.trademark.name}#{%{ #{self.boat_series.name}} if !self.boat_series.nil?} #{self.body_type} #{%{ #{self.name}} if !self.name.blank?}}
  #  %{#{self.trademark_name}#{%{ #{self.series_name}} if !self.series_name.nil?} #{self.body_type} #{%{ #{self.name}} if !self.name.blank?}}
  end
  
  def self.body_types
    select(:body_type).order("body_type ASC").uniq.map{|bt| bt.body_type if !bt.body_type.blank?}
  end
  
  
  #Проверяет наличие стандартов привязанных к boat_type в листе конфигурации. Те которых нет - создает, те которые есть проверяет.
  #Если они есть в модификациях, но нет в списке для сборки - вешается флажок is_active=false, если есть то is_active = true. 
  #Вновь добавленные модификации наследуют название и описание у типа опции
  def check_modifications
    return [] if self.configurator_entities.blank?
    #вытаскиваем все стандарты
    mdfs_in_option_types = BoatOptionType.standarts 
    #вытаскиваем все стандарты из configurator_entities для того чтобы выяснить актуальные типы
    mdfs_in_cnf_ids = self.configurator_entities.where(boat_option_type_id: mdfs_in_option_types.ids).pluck(:boat_option_type_id) 
    return [] if mdfs_in_cnf_ids.blank?
    bt_mdfs = self.boat_type_modifications
    
    if !bt_mdfs.blank? #если есть, то проверяем их актуальность 
      bt_mdfs.each do |mdf|
        idx = mdfs_in_cnf_ids.index(mdf.boat_option_type_id)
        if idx.nil?
          mdf.set_activity_flag(false)
        else
          mdf.set_activity_flag(true)
          mdfs_in_cnf_ids.delete_at(idx)
        end
      end
      
    end 
    add_modifications_by_option_type_ids(mdfs_in_cnf_ids) if !mdfs_in_cnf_ids.blank?
  end
  
  def active_modifications
    boat_type_modifications.where(is_active: true)
  end
  
  def not_active_modifications
    boat_type_modifications.where(is_active: false)
  end
  private
  
  #Достаёт свойства по тэгам 
  def get_property_values_by_tags(tags)
    entity_property_values.includes(:property_type).where(property_types: {tag: ["min_hp", "max_hp"]})
  end
  
  #Добавляет новые модификации по ключам таблицы boat_option_type
  def add_modifications_by_option_type_ids(option_type_ids)
    o_types = BoatOptionType.where(id: option_type_ids)
    mdfs = []
    o_types.each{|t| mdfs.push({boat_option_type_id: t.id, name: t.name, description: t.description}) }
    self.boat_type_modifications.create(mdfs)
  end
  
  def make_boat_parameter_values #создаёт таблицу значений параметров лодки 
    if !copy_params_table_from_id.blank?
      bt = BoatType.find_by(id: copy_params_table_from_id)
      make_clear_parameter_values if bt.nil?
      clone_parameter_values(bt.entity_property_values) if !bt.nil?
    else
      make_clear_parameter_values
    end
  end
  
  def clone_parameter_values(input_vals)
    vals = []
    input_vals.each do |v|
      vals[vals.length] = {set_value: v.get_value, property_type_id: v.property_type_id, is_binded: v.is_binded}
    end
    make_clear_parameter_values if vals.blank?          #если список не сформировался - хуярим пустой список
    entity_property_values.create(vals) if !vals.blank?  #если список сформировался - создаем
  end
  def make_clear_parameter_values #создает новую таблицу параметров
    vals = []
    PropertyType.where(id: BoatPropertyType.all.pluck(:property_type_id)).each do |t|
      vals[vals.length] = {set_value: t.default_value, property_type_id: t.id, is_binded: true}
    end
    entity_property_values.create vals
  end
  
  def cnf_folder_name #папка в которой хранятся файлы конфигуратора
    "configurator/configurator_js_data"
  end
  
  def cnf_file_name 
    "boatOptions_#{self.id}.js"
  end
  
  

end

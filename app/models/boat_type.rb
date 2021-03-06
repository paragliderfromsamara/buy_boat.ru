class BoatType < ApplicationRecord
  
  #copy_params_table_from_id - id типа лодки с которой копируется таблица характеристик
  #modifications_number - количество модификаций, которые автоматически добавляются при создании лодки (если не указано, то создается 1)
  
  attr_accessor :copy_params_table_from_id, :modifications_number, :delete_view, :aft_view_cache, :bow_view_cache, :top_view_cache, :accomodation_view_1_cache, :accomodation_view_2_cache, :accomodation_view_3_cache
    
  after_create :make_boat_parameter_values, :make_modifications, :set_default_url_name 
  before_save :sync_general_attrs_on_modifications, :set_en_name, :check_technical_views_del_flag
  before_validation :set_general_attrs_on_modification #устанавливает общие атрибуты у модификации с базовым типом
  
  #связи для отношения boat_type <- modifications  
  has_many :modifications, class_name: 'BoatType', foreign_key: 'boat_type_id', dependent: :destroy
  belongs_to :boat_type, class_name: 'BoatType', validate: false, optional: true
  #связи для отношения boat_type <- modifications  end
  
  has_many :entity_property_values, as: :entity, dependent: :delete_all
  accepts_nested_attributes_for :entity_property_values
  
  has_many :entity_photos, as: :entity, dependent: :delete_all
  has_many :photos, through: :entity_photos
  #belongs_to :photo
  
  has_many :boat_videos, dependent: :delete_all
  
  belongs_to :boat_series, optional: true, validate: false
  belongs_to :trademark#, optional: true #, validate: false, optional: true
  
  has_many :boat_for_sales, dependent: :destroy
  
  has_many :configurator_entities, dependent: :destroy
  accepts_nested_attributes_for :configurator_entities

  mount_uploader :aft_view, ModificationViewsUploader
  mount_uploader :bow_view, ModificationViewsUploader
  mount_uploader :top_view, ModificationViewsUploader
  mount_uploader :accomodation_view_1, ModificationViewsUploader
  mount_uploader :accomodation_view_2, ModificationViewsUploader
  mount_uploader :accomodation_view_3, ModificationViewsUploader
  
  validate :ru_name_presence, :name_uniqueness
  
  #флаги на удаление видов при редактирования в меню control
  def check_technical_views_del_flag
    return if delete_view.blank?
    case delete_view
    when 'top_view'
      self.remove_top_view!
    when 'bow_view'
      self.remove_bow_view!
    when 'aft_view'
      self.remove_aft_view!
    when 'accomodation_view_1'
      self.remove_accomodation_view_1!
    when 'accomodation_view_2'
      self.remove_accomodation_view_2!
    when 'accomodation_view_3'
      self.remove_accomodation_view_3!
    end
  end
  
  def self.default_scope
    order("created_at ASC")
  end
  
  def ru_name_presence
    msg = is_modification? ? "Компановка не может быть без названия" : "Лодка не может быть без названия"
    if new_record?
      errors.add(:ru_name, msg) if ru_name.blank?  
    else
      errors.add(:ru_name, msg) if ru_name.blank? && !ru_name.nil?
    end
  end
  
  def model_views
    views = []
    views.push({title: 'top_view', small: top_view.small.url, medium: top_view.medium.url, large: top_view.large.url}) if !top_view.blank?
    views.push({title: 'bow_view', small: bow_view.small.url, medium: bow_view.medium.url, large: bow_view.large.url}) if !bow_view.blank?
    views.push({title: 'aft_view', small: aft_view.small.url, medium: aft_view.medium.url, large: aft_view.large.url}) if !aft_view.blank?
    return views
  end
  
  def accomodation_views
    views = []
    views.push({small: accomodation_view_1.small.url, medium: accomodation_view_1.medium.url, large: accomodation_view_1.large.url}) if !accomodation_view_1.blank?
    views.push({small: accomodation_view_2.small.url, medium: accomodation_view_2.medium.url, large: accomodation_view_2.large.url}) if !accomodation_view_2.blank?
    views.push({small: accomodation_view_3.small.url, medium: accomodation_view_3.medium.url, large: accomodation_view_3.large.url}) if !accomodation_view_3.blank?
    return views
  end
  
  def name_uniqueness
    return if ru_name.nil? && en_name.nil?
    if is_modification?
      ru_err_msg = "Компоновка с таким русским названием у лодки #{self.boat_type.catalog_name} уже существует"
      en_err_msg = "Компоновка с таким английским названием у лодки #{self.boat_type.catalog_name} уже существует"
      ru_names = ru_name.blank? ? [] : self.boat_type.modifications.where.not(id: self.id).pluck(:ru_name).map{|n| n.nil? ? '' : n.mb_chars.downcase.to_s}
      en_names = en_name.blank? ? [] : self.boat_type.modifications.where.not(id: self.id).pluck(:en_name).map{|n| n.nil? ? '' : n.mb_chars.downcase.to_s}
    else
      ru_err_msg = "Лодка #{catalog_name} уже существует"
      en_err_msg = "Лодка с английским названием #{catalog_name('en')} уже существует"
      ru_names = ru_name.blank? ? [] : BoatType.base_types.where.not(id: id).where(trademark_id: self.trademark_id).pluck(:ru_name).map{|n| n.nil? ? '' : n.mb_chars.downcase.to_s}
      en_names = en_name.blank? ? [] : BoatType.base_types.where.not(id: id).where(trademark_id: self.trademark_id).pluck(:en_name).map{|n| n.nil? ? '' : n.mb_chars.downcase.to_s}
    end
    if !ru_name.nil?
      errors.add(:ru_name, ru_err_msg) if !ru_names.index(ru_name.mb_chars.downcase.to_s).nil?
    end
    if !en_name.nil?
      errors.add(:en_name, en_err_msg) if !en_names.index(en_name.mb_chars.downcase.to_s).nil?
    end
  end
  
  
  #вытаскивает типы лодок не имеющие модификаций
  def self.base_types
    where(boat_type_id: nil)
  end
  
  def self.modification_types
    where.not(boat_type_id: nil)
  end
  
  def self.on_tm_site_boats(site_tag) # выдает список лодок, в соответстивии с сайтом производителя
    tm = Trademark.find_by(site_tag: site_tag)
    return tm.nil? ? [] : tm.boat_types
  end
  
  def self.property_types
    PropertyType.all.joins(:boat_property_type).select(
                                                      "
                                                        property_types.ru_name AS ru_name,
                                                        property_types.en_name AS en_name,
                                                        property_types.ru_measure AS ru_measure,
                                                        property_types.en_measure AS en_measure,
                                                        property_types.ru_short_name AS ru_short_name,
                                                        property_types.en_short_name AS en_short_name,
                                                        property_types.tag AS tag,
                                                        property_types.value_type AS value_type,
                                                        boat_property_types.property_type_id AS id,
                                                        boat_property_types.order_number AS order_number
                                                      "
                                                    ).order("boat_property_types.order_number ASC")
  end
  
  def copy_photos_from(bt)
    phsFromIds = bt.photos.ids
    phsToIds = self.photos.ids#(:photo_id)
    phsFromIds -= phsToIds
    if phsFromIds.length > 0
      phsFromIds = Photo.where(id: phsFromIds)
      self.photos << phsFromIds
    end
    return self.entity_photos
  end
  

  
  def property_values(locale = nil)
    #вытаскивает список характеристик типа лодки
    EntityPropertyValue.boat_type_property_values(self, locale)
  end
  
  def property_values_hash(locale = nil)
    EntityPropertyValue.boat_type_property_values_hash(self, locale)
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
  
  def self.show_page_scope
    joins(:trademark).includes(:photos)#.active
  end 
  
  def self.all_modifications
    where.not(boat_type_id: nil)
  end
  
  def self.with_bfs
    active.includes(:boat_for_sales)
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
      #self.check_modifications #ищем в загруженном файле стандарты и вносим их в список модификаций
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
  
  def name(locale='ru')
    attr_by_locale('name', locale)
  end
  
  def description(locale='ru')
    attr_by_locale('description', locale)
  end
  
  def slogan(locale='ru')
    attr_by_locale('slogan', locale)
  end
  

  #подготавливает тип лодки для отрисовки React.js, в boat_types/show
  def hash_view(site = 'shop', locale = nil)
    case site
    when 'realcraft'
      locale = 'ru' if locale.blank?
      return realcraft_hash(locale)
    when 'shop', 'salut'
      locale = 'ru' if locale.nil?
      return default_hash(locale)
    when 'control'
      return control_hash
    else
      return default_hash(locale)
    end
  end
  
  def is_modification?
    !boat_type_id.nil? || !self.boat_type_id.nil?
  end
  
  
  def catalog_name(locale='ru') #название типа лодки с наименованием производителя, серией и типом корпуса
    if is_modification? 
      %{#{self.trademark.name} #{self.boat_type.name(locale)} #{self.name(locale)}}
    else
        %{#{self.trademark.name} #{self.name(locale)}}
    end
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
  
  def self.modifications_with_types
    types 
    
  end
  
  def active_modifications
    modifications.where(is_active: true)
  end
  
  def not_active_modifications
    modifications.where(is_active: false)
  end
  
  #Ищет основное фото на сущности
  def main_photo
    if is_modification? 
      ph = EntityPhoto.main_photo(self)
      return ph.nil? ? EntityPhoto.main_photo(boat_type) : ph
    else
      EntityPhoto.main_photo(self)
    end
  end
  
  #Ищет основное фото на сущности и возвращает в виде хэша
  def main_photo_hash_view
    ph = main_photo
    return nil if ph.nil? 
    ph.hash_view  
  end
  
  #Перенесено в ApplicationRecord
  #def photos_hash_view(is_wide=false)
  #  return "" if photos.blank?
  #  photos.map {|ph| ph.hash_view(is_wide)}
  #end
  
  def realcraft_hash(locale)
    if is_modification?
    {
      id: self.id,
      name: name,
      description: description(locale),
      properties: self.property_values_hash(locale),
      type: 'modification',
      model_views: model_views,
      accomodation_views: accomodation_views#,
      #boat_for_sales: BoatForSale.filtered_collection(self.boat_for_sales.ids)#.select(:id, :amount)#.includes(:selected_options).map {|bfs| {id: bfs.id, selectedOptions: bfs.selected_options_for_show}} #.with_selected_options
    }
    else
      {
        id: self.id,
        body_type: self.body_type,
        design_category: self.design_category,
        trademark: self.trademark.hash_view,
        modifications: self.modifications.map{|mdf| mdf.realcraft_hash(locale)},
        name: self.catalog_name(locale),
        description: description(locale),
        slogan: slogan(locale),
        photo: main_photo_hash_view, 
        photos: self.entity_photos_hash_view,
        videos: self.boat_videos.map{|v| v.hash_view},
        type: 'boat_type'
        #boat_for_sales: BoatForSale.filtered_collection(self.boat_for_sales.ids)#.select(:id, :amount)#.includes(:selected_options).map {|bfs| {id: bfs.id, selectedOptions: bfs.selected_options_for_show}} #.with_selected_options
      }
    end
  end
  
  def default_hash(locale)
    if is_modification?
    {
      id: self.id,
      name: boat_type.name(locale),
      description: boat_type.description(locale),
      slogan: boat_type.slogan(locale),
      body_type: self.boat_type.body_type,
      modification_name: name,
      modification_description: description(locale),
      photo: main_photo_hash_view, 
      properties: self.property_values_hash(locale),
      photos: self.photos_hash_view,
      type: 'modification'#,
      #boat_for_sales: BoatForSale.filtered_collection(self.boat_for_sales.ids)#.select(:id, :amount)#.includes(:selected_options).map {|bfs| {id: bfs.id, selectedOptions: bfs.selected_options_for_show}} #.with_selected_options
    }
    else
      {
        id: self.id,
        body_type: self.body_type,
        trademark: self.trademark.hash_view,
        modifications: self.modifications.map{|mdf| mdf.default_hash(locale)},
        name: self.catalog_name(locale),
        description: description(locale),
        slogan: slogan(locale),
        photo: main_photo_hash_view, 
        photos: self.photos_hash_view,
        type: 'boat_type'
        #boat_for_sales: BoatForSale.filtered_collection(self.boat_for_sales.ids)#.select(:id, :amount)#.includes(:selected_options).map {|bfs| {id: bfs.id, selectedOptions: bfs.selected_options_for_show}} #.with_selected_options
      }
    end
  end
  
  def control_hash
    if !is_modification?
    {
       id: self.id,
       ru_name: self.ru_name,
       en_name: self.en_name,
       trademark_name: trademark.nil? ? 'Не выбрана' : trademark.name,
       trademark_id: self.trademark_id,
       boat_series_name: boat_series.nil? ? 'Вне серии' : boat_series.name,
       boat_series_id: self.boat_series_id,
       body_type: self.body_type,
       ru_description: self.ru_description,
       en_description: self.en_description,
       ru_slogan: self.ru_slogan,
       en_slogan: self.en_slogan,
       design_category: self.design_category,
       use_on_ru: self.use_on_ru,
       use_on_en: self.use_on_en,
       is_active: self.is_active,
       is_deprecated: self.is_deprecated,
    }
    else
      {
         id: self.id,
         ru_name: self.ru_name,
         en_name: self.en_name,
         ru_description: self.ru_description,
         en_description: self.en_description,
         properties: self.property_values_hash,
         use_on_ru: self.use_on_ru,
         use_on_en: self.use_on_en,
         is_active: self.is_active,
         is_deprecated: self.is_deprecated,
         top_view: top_view.nil? ? '' : top_view.url,
         bow_view: bow_view.nil? ? '' : bow_view.url,
         aft_view: aft_view.nil? ? '' : aft_view.url,
         accomodation_view_1: accomodation_view_1.nil? ? '' : accomodation_view_1.url,
         accomodation_view_2: accomodation_view_2.nil? ? '' : accomodation_view_2.url,
         accomodation_view_3: accomodation_view_3.nil? ? '' : accomodation_view_3.url,
         photos: self.entity_photos.map {|ph| ph.hash_view}
      }
    end
  end
  
  private
  
  def check_attributes_for_modification #добавляет к атрибутам 
    return if !is_modification?
    trademark_id = boat_type.trademark_id
    boat_series_id = boat_type.boat_series_id
    body_type = boat_type.body_type
  end
  

  
  #Достаёт свойства по тэгам 
  def get_property_values_by_tags(tags)
    entity_property_values.includes(:property_type).where(property_types: {tag: tags})
  end
  
  #Добавляет новые модификации по ключам таблицы boat_option_type
  def add_modifications_by_option_type_ids(option_type_ids)
    return
    #o_types = BoatOptionType.where(id: option_type_ids)
    #mdfs = []
    #o_types.each{|t| mdfs.push({boat_option_type_id: t.id, ru_name: t.name, ru_description: t.description}) }
    #self.boat_type_modifications.create(mdfs)
  end
  
  def make_boat_parameter_values #создаёт таблицу значений параметров лодки 
    return if !is_modification?
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
      vals[vals.length] = {set_en_value: v.get_value('en'), set_ru_value: v.get_value('ru'), property_type_id: v.property_type_id, is_binded: v.is_binded}
    end
    make_clear_parameter_values if vals.blank?          #если список не сформировался - хуярим пустой список
    entity_property_values.create(vals) if !vals.blank?  #если список сформировался - создаем
  end
  
  #Создаёт модификации на базовом типе в зависимости от количества указанного в атрибуте modifications_number
  #Протестированно в Тест создания модификаций при добавлении нового типа лодки
  def make_modifications
    return if is_modification?
    self.modifications_number = modifications_number.blank? || modifications_number == 0 ? 1 : modifications_number
    self.modifications_number = 5 if self.modifications_number > 5
    mdfs = []
    self.modifications_number.times do |n|
      mdfs.push({ru_name: "Компоновка #{n+1}", en_name: "Consumption #{n+1}"})
    end 
    self.modifications.create(mdfs)
  end
  
  def make_clear_parameter_values #создает новую таблицу параметров
    EntityPropertyValue.make_default_values(self)
    #vals = []
    #PropertyType.where(id: BoatPropertyType.all.pluck(:property_type_id)).each do |t|
    #  vals[vals.length] = {set_en_value: t.default_value, set_ru_value: t.default_value, property_type_id: t.id, is_binded: true}
    #end
    #entity_property_values.create vals
  end
  
  def cnf_folder_name #папка в которой хранятся файлы конфигуратора
    "configurator/configurator_js_data"
  end
  
  def cnf_file_name 
    "boatOptions_#{self.id}.js"
  end
  
  #при удалении или добавлении модификации, проверяет флаг has_modifications на типе лодки. 
  #Если модификаций раньше не было, то флаг has_modifications = true
  #Если при удалении данная модификация последняя, то has_modifications = false
  #протестировано в test/models/mdification_test.rb "Тест изменения has_modifications флага"
  def check_has_modifications_flag #проверка флага has_modifications на boat_type после создания и удаления модификации
    return if !is_modification?
    hasMdfsFlag = self.boat_type.has_modifications
    hasMdfs = !self.boat_type.reload.modifications.blank?
    self.boat_type.update_attribute(:has_modifications, hasMdfs) if hasMdfsFlag != hasMdfs
  end
  
  #При добавлении новой модификации копирует атрибуты trademark_id, boat_series_id, body_type из типа лодки
  #Копирует таблицу параметров с типа лодки
  #протестировано в test/models/mdification_test.rb "Тест на обновление атрибутов связей boat_series_id trademark_id, также и body_type"
  def set_general_attrs_on_modification
    return if !is_modification? || !new_record?
    self.boat_series_id = self.boat_type.boat_series_id
    self.trademark_id = self.boat_type.trademark_id
    self.body_type = self.boat_type.body_type
    self.copy_params_table_from_id = self.boat_type.id if copy_params_table_from_id.blank?
  end
  
  
  #при изменении атрибутов boat_series_id, trademark_id, body_type в типе лодки, обновляет данные атрибуты на всех модификациях
  #протестировано в test/models/mdification_test.rb "Тест на обновление атрибутов связей boat_series_id trademark_id, также и body_type"
  def sync_general_attrs_on_modifications
    return if !boat_series_id_changed? && !trademark_id_changed? && !body_type_changed?
    self.modifications.each do |mdf|
      mdf.update_attributes(trademark_id: self.trademark_id, boat_series_id: self.boat_series_id, body_type: self.body_type) 
    end
  end
  
  def set_en_name
    self.en_name = ru_name if en_name.blank?
  end
  
  def set_default_url_name
    return if !self.url_name.blank?
    self.update_attribute(:url_name, is_modification? ? "modification_#{id}" : "boat_type_#{id}" )
  end

  
end

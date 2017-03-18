class BoatType < ApplicationRecord
  after_create :make_boat_parameter_values
  belongs_to :creator, class_name: "User" #кто создал
  belongs_to :modifier, class_name: "User" #кто изменил
  
  
  has_many :boat_photos, dependent: :delete_all
  has_many :photos, through: :boat_photos
  #belongs_to :photo
  
  has_many :boat_parameter_values, dependent: :delete_all
  belongs_to :boat_series, optional: true, validate: false
  belongs_to :trademark
  
  accepts_nested_attributes_for :photos
  
  has_many :configurator_entities, dependent: :destroy
  accepts_nested_attributes_for :configurator_entities
  
  
  
  def alter_photo
    photos.first
  end
  
  def photos_hash_view
    return "" if photos.blank?
    photos.map {|ph| ph.hash_view}
  end
  
  def self.show_page_scope
    joins(:trademark).includes(:photos)#.active
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
  
  def photos_attributes=(attrs)
    if !attrs.blank?
      self.photos.create(attrs)
      #attrs.each {|ph| self.photos.create(link: ph[:link], uploader_id: self.modifier_id)}
    end
  end
  
  def configurator_entities_attributes=(attrs)
    if !attrs.blank?
      self.configurator_entities.delete_all
      attrs.values.each do |a|
        if !a[:param_code].blank?
          option_type = BoatOptionType.find_by(param_code: a[:param_code])
          option_type = BoatOptionType.create(name: a[:param_name], param_code: a[:param_code], rec_type: a[:rec_type], amount: a[:price], description: a[:comment]) if option_type.nil?
          a[:boat_option_type_id] = option_type.id
        end
      end  
      self.configurator_entities.create(attrs.values)
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
  
  def hash_view
    {
      type: self,
      parameters: self.boat_parameters_for_react,
      photos: self.photos_hash_view
    }
  end
  
  def boat_parameters_for_react #для скармливания React.js
    boat_parameter_values.for_react.map {|v| {id: v.id, name: v.name_and_measure, boat_type_id: self.id, short_name: v.name_and_measure(true), value_type: v.get_value_type, number: v.number, value: v.get_value, is_binded: v.is_binded}}
  end
  
  def catalog_name #название типа лодки с наименованием производителя, серией и типом корпуса
    %{#{self.trademark.name}#{%{ #{self.boat_series.name}} if !self.boat_series.nil?} #{self.body_type} #{%{ #{self.name}} if !self.name.blank?}}
  #  %{#{self.trademark_name}#{%{ #{self.series_name}} if !self.series_name.nil?} #{self.body_type} #{%{ #{self.name}} if !self.name.blank?}}
  end
  
  def self.body_types
    select(:body_type).order("body_type ASC").uniq.map{|bt| bt.body_type if !bt.body_type.blank?}
  end
    
  private
  
  def make_boat_parameter_values #создаёт таблицу значений параметров лодки 
    vals = []
    BoatParameterType.all.each do |t|
      vals[vals.length] = {set_value: t.default_value, boat_parameter_type_id: t.id, is_binded: true}
    end
    boat_parameter_values.create vals
  end
  
  def cnf_folder_name #папка в которой хранятся файлы конфигуратора
    "configurator/configurator_js_data"
  end
  
  def cnf_file_name 
    "boatOptions_#{self.id}.js"
  end
  

end

class BoatType < ApplicationRecord
  after_create :make_boat_parameter_values
  belongs_to :creator, class_name: "User" #кто создал
  belongs_to :modifier, class_name: "User" #кто изменил
  
  
  has_many :boat_photos, dependent: :delete_all
  has_many :photos, through: :boat_photos
  belongs_to :photo
  
  has_many :boat_parameter_values, dependent: :delete_all
  belongs_to :boat_series, optional: true, validate: false
  belongs_to :trademark
  
  accepts_nested_attributes_for :photos
  
  def alter_photo
    photo.nil? ? photos.first : photo 
  end
  
  def photos_hash_view
    return "" if photos.blank?
    photos.map {|ph| ph.hash_view}
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
  
  def boat_parameters_for_react #для скармливания React.js
    boat_parameter_values.for_react.map {|v| {id: v.id, name: v.name_and_measure, boat_type_id: self.id, short_name: v.name_and_measure(true), value_type: v.get_value_type, number: v.number, value: v.get_value, is_binded: v.is_binded}}
  end
  
  def catalog_name #название типа лодки с наименованием производителя, серией и типом корпуса
    %{#{self.trademark.name}#{%{ #{self.boat_series.name}} if !self.boat_series.nil?} #{self.body_type}}
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
  
end

class BoatType < ApplicationRecord
  after_create :make_boat_parameter_values
  belongs_to :creator, class_name: "User" #кто создал
  belongs_to :modifier, class_name: "User" #кто изменил
  
  has_many :boat_parameter_values, dependent: :delete_all
  belongs_to :boat_series, optional: true
  belongs_to :trademark
  
  
  
  def self.active #лодки которые показываются в каталоге
    where(is_deprecated: false, is_active: true)
  end
  
  def self.not_active  #лодки которые по каким-то причинам не показаны в каталоге, к примеру
    where(is_deprecated: false, is_active: false)
  end
  
  def self.deprecated  #устаревшие
    where(is_deprecated: true)
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
  

  #def self.max_hp
  #  select(:max_hp).order("max_hp ASC").uniq.map{|bt| bt.max_hp if !bt.max_hp.blank?}
  #end
  
  #def self.min_hp
  #  select(:min_hp).order("min_hp ASC").uniq.map{|bt| bt.min_hp if !bt.min_hp.blank?}
  #end
  
  #def self.hull_width
  #  select(:hull_width).order("hull_width ASC").uniq.map{|bt| bt.hull_width if !bt.hull_width.blank?}
  #end
  
  #def self.hull_length
  #  select(:hull_length).order("hull_length ASC").uniq.map{|bt| bt.hull_length if !bt.hull_length.blank?}
  #end
  
  private
  
  def make_boat_parameter_values #создаёт таблицу значений параметров лодки 
    vals = []
    BoatParameterType.all.each do |t|
      vals[vals.length] = {set_value: t.default_value, boat_parameter_type_id: t.id, is_binded: true}
    end
    boat_parameter_values.create vals
  end
  
end

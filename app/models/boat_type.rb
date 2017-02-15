class BoatType < ApplicationRecord
  after_create :make_boat_parameter_values
  belongs_to :creator, class_name: "User" #кто создал
  belongs_to :modifier, class_name: "User" #кто изменил
  
  has_many :boat_parameter_values, dependent: :delete_all
  belongs_to :boat_series, optional: true
  belongs_to :trademark

  
  def self.for_catalog #то что отображается в каталоге
    where(is_deprecated: false, is_active: true)
  end
  
  def boat_parameters
   #boat_parameter_values.joins(:boat_parameter_type).order("boat_parameter_types.number ASC").select("boat_parameter_types.name as name AND boat_parameter_types.value_type AS value_type AND boat_parameter_values.integer_value AND boat_parameter_values.string_value AND boat_parameter_values.bool_value AND boat_parameter_values.float_value AND boat_parameter_types.number AS number")
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
      vals[vals.length] = {set_value: t.default_value, boat_parameter_type_id: t.id}
    end
    boat_parameter_values.create vals
  end
  
end

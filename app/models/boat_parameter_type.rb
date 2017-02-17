class BoatParameterType < ApplicationRecord
  
  has_many :boat_parameter_values, dependent: :delete_all 
  
  before_save :set_number, on: :create
  
  after_create :create_boat_parameter_values, on: :create
  
  after_destroy :reordering_numbers
  
  before_validation :set_value_type_as_was #не даёт изменить тип параметра
  
  validates :value_type, inclusion: { in: %w(integer bool float string)}
  
  
  default_scope { order("number ASC") }
  
  def default_value
    case value_type
    when "integer"
      0
    when "bool"
      false
    when "float"
      0.0
    else
      ""
    end
  end
  
  #def name_and_measure(short = false)
  # return %{#{name}#{", #{measure}" if !measure.blank?}} if !short || (short && short_name.blank?)
  # return %{#{short_name}#{", #{measure}" if !measure.blank?}}
  #end
  
  def self.json_view
    all.map {|t| {id: t.id, name: t.name, number: t.number, short_name: t.short_name, measure: t.measure, value_type: t.value_type_ru, is_use_on_filter: t.show_in_filter_ru}}
  end
  
  def self.measures
    select(:measure).reorder("measure ASC").distinct.collect {|m| m.measure}
  end
  def self.accessible_value_types
    [["текст", "string"], ["целый", "integer"], ["десятичный", "float"], ["да/нет", "bool"]]
  end
  
  def value_type_ru 
    BoatParameterType.accessible_value_types.each {|vt| return vt[0] if vt[1] == value_type}
  end
  
  def show_in_filter_ru
    is_use_on_filter ? "check" :  "x" #такие значение возвращаются чтобы отрисовать foundation icons через utils.coffee
  end
  
  private 
  def set_value_type_as_was #не даёт изменить тип параметра
    return if new_record? || !value_type_changed?
    self.value_type = value_type_was
  end
  
  def create_boat_parameter_values #добавляет ссылку к каждой лодке
    vals = []
    BoatType.all.each {|bt| vals[vals.length] = {boat_type_id: bt.id, is_binded: false, set_value: default_value}}
    boat_parameter_values.create(vals) if !vals.blank?
  end 
  
  def set_number
    return if !new_record?
    last_type = BoatParameterType.all.last
    self.number = last_type.nil? ? 1 : (last_type.number + 1)
  end
  
  def reordering_numbers
    i = 1
    BoatParameterType.all.each do |t|
      t.update_attribute(:number, i)
      i+=1
    end
  end
    
end

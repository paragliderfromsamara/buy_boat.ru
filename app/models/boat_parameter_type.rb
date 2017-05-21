class BoatParameterType < ApplicationRecord
  
  has_many :boat_parameter_values, dependent: :delete_all 
  
  before_save :set_number, on: :create
  
  after_create :create_boat_parameter_values#, on: :create
  
  after_destroy :reordering_numbers
  
  before_validation :set_value_type_as_was #не даёт изменить тип параметра
  
  validates :value_type, inclusion: { in: %w(integer bool float string option)}
  
  def self.value_types
    [
      ['integer', "целочисленный"],
      ['bool', "да/нет"],
      ['float', "десятичный"],
      ['string', "текст"],
      ['option', 'опция (связь по тэгу)']
    ]
  end
  
  def self.filter_data
    filterItems = {}
    where(tag: ["max_hp", "min_hp", "max_length", "min_length"]).includes(:boat_parameter_values).each{|t| filterItems[t.tag.to_sym] = {
                                                                                    name: t.name, 
                                                                                    s_name: t.short_name,
                                                                                    values: t.boat_parameter_values.active.to_a.map{|v| {b_id: v.boat_type_id, value: v.get_value, is_binded: v.is_binded}}
                                                                                }} 
                                                                                    #}
                                                                                    return filterItems
  end
  
  def self.default_scope 
    order("number ASC")
  end
  
  def self.min_hp_id
    min = BoatParameterType.min_hp
    return min.nil? ? 0 : min.id
  end
  
  def self.max_hp_id 
    max =  BoatParameterType.max_hp
    return max.nil? ? 0 : max.id
  end
  
  def self.max_hp #ищет параметер с тегом обозначающим max_hp
    find_by(tag: "max_hp")
  end
  
  def self.min_hp #ищет параметер с тегом обозначающим min_hp
    find_by(tag: "min_hp")
  end
  
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
    all.map {|t| {id: t.id, name: t.name, number: t.number, short_name: t.short_name, measure: t.measure, value_type: t.value_type_ru, is_use_on_filter: t.show_in_filter_ru, tag: t.tag}}
  end
  
  def self.measures
    select(:measure).reorder("measure ASC").distinct.collect {|m| m.measure}
  end
  def self.accessible_value_types
    [
      ["текст", "string"], 
      ["целый", "integer"], 
      ["десятичный", "float"], 
      ["да/нет", "bool"], 
      ["опция", "option"]
    ]
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

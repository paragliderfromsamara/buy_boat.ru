class BoatParameterType < ApplicationRecord
  attr_accessor :skip_before_save
  has_many :boat_parameter_values, dependent: :delete_all 
  #before_save :update_numbers
  before_save :set_number, on: :create
  after_create :create_boat_parameter_values, on: :create
  after_destroy :reordering_numbers
  
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
    order("number ASC").map {|t| {id: t.id, name: t.name, number: t.number, short_name: t.short_name, measure: t.measure, value_type: t.value_type_ru, is_use_on_filter: t.show_in_filter_ru}}
  end
  
  def self.measures
    select(:measure).order("measure ASC").uniq.collect {|m| m.measure}
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
  
  def update_numbers
    return if self.skip_before_save || new_record?
    if self.number_was != number
      i = 0
      BoatParameterType.order("number ASC").each do |pt| 
        if pt.id != self.id
          i += 1
          i = i == number ? i+1 : i
          pt.update_attributes(number: i, skip_before_save: true)
        end
      end
    end
  end
  
  private 
  
  def create_boat_parameter_values
    vals = []
    BoatType.all.each {|bt| vals[vals.length] = {boat_type_id: bt.id, is_binded: false, set_value: default_value}}
    boat_parameter_values.create(vals) if !vals.blank?
  end 
  
  def set_number
    return if !new_record?
    last_type = BoatParameterType.order("number ASC").last
    self.number = last_type.nil? ? 1 : last_type.number + 1
  end
  
  def reordering_numbers
    i = 1
    BoatParameterType.order("number ASC").each do |t|
      t.update_attribute(:number, i)
      i+=1
    end
  end
    
end

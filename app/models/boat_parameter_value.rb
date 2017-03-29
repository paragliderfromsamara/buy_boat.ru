class BoatParameterValue < ApplicationRecord
  attr_accessor :set_value
  
  before_validation :select_value_type
  belongs_to :boat_parameter_type, optional: :true
  belongs_to :boat_type, optional: :true
  
  def self.active
    where(boat_type_id: BoatType.active.ids)
  end
  
  def self.for_react
    joins(:boat_parameter_type).select(
            "boat_parameter_values.id AS id, 
             boat_parameter_values.boat_type_id AS boat_type_id, 
             boat_parameter_values.integer_value AS integer_value, 
             boat_parameter_values.string_value AS string_value, 
             boat_parameter_values.bool_value AS bool_value, 
             boat_parameter_values.float_value AS float_value, 
             boat_parameter_values.is_binded AS is_binded, 
             boat_parameter_types.name as name, 
             boat_parameter_types.tag as tag,
             boat_parameter_types.value_type AS value_type, 
             boat_parameter_types.number AS number, 
             boat_parameter_types.measure AS measure, 
             boat_parameter_types.short_name AS short_name").order("boat_parameter_types.number ASC")
  end 
  
  def get_value 
    return self["#{get_value_type}_value".to_sym] if get_value_type != "option"
    return "-" if tag.blank?
    ce = boat_type.configurator_entities.where(boat_option_type_id: BoatOptionType.select(:id).where(tag: get_tag))
    if ce.blank?
      v = "-"
    else
      v = ce.to_a.map{|c| c.boat_option_type.s_name }.join(", ")
    end
    return v
  end
  
  def get_tag
    return boat_parameter_type.tag if !has_attribute?(:tag)
    return tag
  end
  
  def get_value_type
    return boat_parameter_type.value_type if !has_attribute?(:value_type)
    return value_type
  end
  
  def name_and_measure(short = false)
   return %{#{name}#{", #{measure}" if !measure.blank?}} if !short || (short && short_name.blank?)
   return %{#{short_name}#{", #{measure}" if !measure.blank?}}
  end
  
  private
  
  def select_value_type 
    self.set_value = "" if set_value.nil?
    case get_value_type
    when "string"
      self.string_value = set_value.to_s
    when "bool"
      if set_value.class.name == "FalseClass" || set_value.class.name == "TrueClass"
        self.bool_value = set_value
      elsif set_value.to_i > 0
        self.bool_value = true
      elsif set_value.class.name == "String"
        self.bool_value = set_value.index("false").nil? && !set_value.blank? 
      else
        self.bool_value = false
      end
    when "integer"
      if set_value == false || set_value == true
        self.integer_value = set_value ? 1 : 0
      else
        self.integer_value = set_value.to_i
        
      end
    when "float"    
      if set_value == false || set_value == true
        self.float_value = set_value ? 1.0 : 0.0
      else
        self.float_value = set_value.to_f
      end
    end
  end

end

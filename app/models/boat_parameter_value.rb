class BoatParameterValue < ApplicationRecord
  attr_accessor :set_value
  
  before_validation :select_value_type
  belongs_to :boat_parameter_type
  belongs_to :boat_type
  
  default_scope {joins(:boat_parameter_type).select("boat_parameter_values.id, boat_parameter_values.is_binded, boat_parameter_types.name as name, boat_parameter_types.value_type AS value_type, boat_parameter_values.integer_value, boat_parameter_values.string_value, boat_parameter_values.bool_value, boat_parameter_values.float_value, boat_parameter_types.number AS number, boat_parameter_types.measure AS measure, boat_parameter_types.short_name AS short_name" ).order("boat_parameter_types.number ASC")} 

  def get_value 
    self["#{get_value_type}_value".to_sym]
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

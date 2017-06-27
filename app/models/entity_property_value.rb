class EntityPropertyValue < ApplicationRecord
  attr_accessor :set_value
  
  belongs_to :property_type
  belongs_to :entity, polymorphic: true #product или boat_type
  before_validation :select_value_type
  
  def get_value 
    return self["#{get_value_type}_value".to_sym] if get_value_type != "option"
    #раскоментировать после присоединения к этой таблице типов лодок
    return "-" if property_type.tag.blank? || entity_type != "BoatType"
    ce = entity.configurator_entities.where(boat_option_type_id: BoatOptionType.select(:id).where(tag: property_type.tag))
    if ce.blank?
      v = "-"
    else
      v = ce.to_a.map{|c| c.boat_option_type.s_name }.join(", ")
    end
    return v
  end
  
  def get_value_type
    !has_attribute?(:value_type) ? property_type.value_type : value_type
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

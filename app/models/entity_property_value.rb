class EntityPropertyValue < ApplicationRecord
  attr_accessor :set_ru_value, :set_com_value
  
  belongs_to :property_type
  belongs_to :entity, polymorphic: true #product или boat_type
  before_validation :select_value_type
  
  def get_value(locale='ru') 
    return self["#{locale}_#{get_value_type}_value".to_sym] if get_value_type != "option"
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
    return if get_value_type == 'option'
    self["ru_#{get_value_type}_value".to_sym] = identify_value 
    self["com_#{get_value_type}_value".to_sym] = identify_value('com')
  end
  
  def identify_value(locale='ru')
    set_value = locale == 'com' ? self.set_com_value : self.set_ru_value
    case get_value_type
    when "string"
      return set_value.to_s
    when "bool"
      if set_value.class.name == "FalseClass" || set_value.class.name == "TrueClass"
        return set_value
      elsif set_value.to_i > 0
        return true
      elsif set_value.class.name == "String"
        return set_value.index("false").nil? && !set_value.blank? 
      else
        return false
      end
    when "integer"
      if set_value == false || set_value == true
        return set_value ? 1 : 0
      else
        return set_value.to_i
      end
    when "float"    
      if set_value == false || set_value == true
        return set_value ? 1.0 : 0.0
      else
        return set_value.to_f
      end
    end
  end
end

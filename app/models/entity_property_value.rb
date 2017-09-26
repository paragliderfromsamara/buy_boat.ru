class EntityPropertyValue < ApplicationRecord
  attr_accessor :set_ru_value, :set_com_value
  
  belongs_to :property_type
  belongs_to :entity, polymorphic: true #product или boat_type
  before_validation :select_value_type

  def self.boat_type_property_values_hash(entity, locale = nil)
    EntityPropertyValue.boat_type_property_values(entity, locale).to_a.map {|pv| pv.hash_view(locale)}
  end
  
  def self.boat_type_property_values(entity, locale = nil) #entity это boat_type или boat_type_modification
    select_query = "
                       entity_property_values.id AS id,
                       entity_property_values.property_type_id AS property_type_id,
                       property_types.tag AS tag,
                       property_types.value_type AS value_type,
                       boat_property_types.order_number AS order_number,
                       property_types.ru_name AS ru_name,
                       property_types.ru_short_name AS ru_short_name,
                       property_types.ru_measure AS ru_measure,
                       property_types.com_name AS com_name,
                       property_types.com_short_name AS com_short_name,
                       property_types.com_measure AS com_measure,
                       entity_property_values.is_binded AS is_binded,
                       entity_property_values.entity_type AS entity_type,
                       entity_property_values.entity_id AS entity_id,
                       #{EntityPropertyValue.select_values_string_by_locale('ru')},
                       #{EntityPropertyValue.select_values_string_by_locale('com')}
                      "
     if !locale.nil?
       return entity.entity_property_values.joins(property_type: [:boat_property_type]).select(select_query).order("boat_property_types.order_number ASC").where(is_binded: true) 
     else
       return entity.entity_property_values.joins(property_type: [:boat_property_type]).select(select_query).order("boat_property_types.order_number ASC")
     end
  end
  
  def self.select_values_string_by_locale(locale) #используется для извлечения из БД параметров в BoatType.property_values()
    "
     entity_property_values.#{locale}_integer_value AS #{locale}_integer_value,
     entity_property_values.#{locale}_float_value AS #{locale}_float_value,
     entity_property_values.#{locale}_string_value AS #{locale}_string_value,
     entity_property_values.#{locale}_bool_value AS #{locale}_bool_value
    "
  end
  
  def hash_view(locale=nil)
    if !locale.nil?
      {
        name: self["#{locale}_name".to_sym],
        short_name: self["#{locale}_short_name".to_sym],
        measure: self["#{locale}_measure".to_sym],
        value: self.get_value(locale),
        locale: locale
      }
    else
      {
        id: self.id,
        ru_name: self.ru_name,
        ru_short_name: self.ru_short_name,
        ru_measure: self.ru_measure,
        ru_value: self.get_value('ru'),
        com_name: self.com_name,
        com_short_name: self.com_short_name,
        com_measure: self.com_measure,
        com_value: self.get_value('com'),
        is_binded: self.is_binded,
        value_type: self.value_type,
        property_type_id: self.property_type_id
      }
    end
  end 
  
  def get_value(locale='ru') 
    return self["#{locale}_#{get_value_type}_value".to_sym] if get_value_type != "option"
    #раскоментировать после присоединения к этой таблице типов лодок
    return "-" if option_tag.blank? || entity_type != "BoatType"
    ce = entity.configurator_entities.where(boat_option_type_id: BoatOptionType.select(:id).where(tag: option_tag))
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
  
  def option_tag
    !has_attribute?(:tag) ? property_type.tag : tag
  end
  
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

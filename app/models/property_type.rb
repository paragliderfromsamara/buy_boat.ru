class PropertyType < ApplicationRecord
  attr_accessor :name, :short_name, :measure
  before_save :split_attrs_by_locale
  has_many :product_types_property_types, dependent: :delete_all
  has_many :entity_property_values, dependent: :delete_all
  has_one :boat_property_type, dependent: :delete

  
  def self.value_types
    [
      ['integer', "целочисленный"],
      ['bool', "да/нет"],
      ['float', "десятичный"],
      ['string', "текст"],
      ['option', 'опция (связь по тэгу)']
    ]
  end
  
  validates :value_type, inclusion: { in: PropertyType.value_types.map{|t| t[0]}}
  
  def self.for_select_list
    all.select(:ru_name, :id, :ru_measure, :value_type).order("ru_name ASC")
  end
  
  def default_value
    case self.value_type
    when "integer"
      return 0
    when "float"
      return 0.0
    when "bool"
      return true
    when "string"
      return ""
    end
    return ""
  end
  
  def name_and_measure(locale = "ru")
    measure = attr_by_locale("measure", locale)
    measure = measure.blank? ? "" : ", #{measure}"
    return "#{attr_by_locale("name", locale)}#{measure}"
  end
  
  private 
	def split_attrs_by_locale
    #return true if name.blank?
    if !self.name.nil?
      _name = self.split_by_locale(self.name)
      self.en_name = _name[:en]
      self.ru_name = _name[:ru]
    end  
    if !self.short_name.nil?
      _short_name = self.split_by_locale(self.short_name)
      self.en_short_name = _short_name[:en]
      self.ru_short_name = _short_name[:ru]
      #return true if description.blank?
    end  
    if !self.measure.nil?
      _measure = self.split_by_locale(self.measure)
      self.en_measure = _measure[:en]
      self.ru_measure = _measure[:ru]
      #return true if description.blank?
    end  

  end
end

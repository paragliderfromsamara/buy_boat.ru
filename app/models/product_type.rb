class ProductType < ApplicationRecord
  has_many :product_types_property_types, dependent: :delete_all
  has_many :property_types, through: :product_types_property_types
  has_many :products, -> {where(is_draft: false)}, dependent: :destroy 
  before_save :set_plural_name
  accepts_nested_attributes_for :product_types_property_types
  
  def self.not_draft
    where(is_draft: false)#.order("name ASC")
  end
  
  def self.active
    where(is_active: true, is_draft: false)
  end
  
  def self.not_active
    where(is_active: false, is_draft: false)
  end
  def self.default_scope
    order("name ASC")
  end
  
 
  
  def self.draft
    #ProductType.new
    d = ProductType.where(is_draft: true).first
    d = ProductType.create(number_on_boat:1, is_draft: true) if d.nil?
    return d.reload
  end
  
  def product_types_property_types_attributes=(attrs)
    return if new_record? || attrs.nil?
    self.product_types_property_types.delete_all
    self.product_types_property_types.create(attrs.values) if !attrs.blank?
  end
  
  def properties_list #используется для отрисовки формы
      property_types.joins(:product_types_property_types).select(
              "property_types.id AS id, 
               property_types.ru_name AS ru_name,
               property_types.ru_measure AS ru_measure, 
               property_types.value_type AS value_type, 
               product_types_property_types.is_required AS is_required, 
               product_types_property_types.less_than AS less_than,
               product_types_property_types.more_than AS more_than,
               product_types_property_types.equal AS equal,
               product_types_property_types.order_number AS order_number").order("product_types_property_types.order_number ASC").distinct
  end
  
  def hash_view
    {
      id: self.id,
      name: self.name, 
      description: self.description,
      number_on_boat: self.number_on_boat,
      is_enable: self.is_enable,
      property_types: self.property_types
    }
  end
  
  def default_property_values
    return {} if self.property_types.blank?
    v = []
    self.property_types.each do |pt|
      v.push({property_type_id: pt.id, set_value: pt.default_value}) 
    end
    return v.to_ass_hash
  end
  
  private
  
  def set_plural_name
    self.plural_name = name if plural_name.blank?
  end
end

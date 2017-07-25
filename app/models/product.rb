class Product < ApplicationRecord
  belongs_to :product_type
  has_many :entity_property_values, as: :entity, dependent: :delete_all
  has_many :shop_products, dependent: :delete_all
  has_many :entity_photos, as: :entity, dependent: :delete_all
  has_many :photos, through: :entity_photos
  
  accepts_nested_attributes_for :entity_property_values
  
  accepts_nested_attributes_for :photos
  def photos_attributes=(attrs)
    if !attrs.blank?
      self.photos.create(attrs)
      #attrs.each {|ph| self.photos.create(link: ph[:link], uploader_id: self.modifier_id)}
    end
  end
  
  def property_values
    self.entity_property_values.where(property_type_id: product_type.product_types_property_types.pluck(:property_type_id))
  end
  
  def prop_vals_for_shop(locale='ru')
    entity_property_values.includes(property_type: :product_types_property_types).order("product_types_property_types.order_number ASC").to_a.map do |epv| 
      prop_type_prod_type = epv.property_type.product_types_property_types.find_by(product_type_id: product_type_id, property_type: epv.property_type.id)
      {
      id: epv.property_type_id,
      name: epv.property_type["#{locale}_name".to_sym],
      short_name: epv.property_type["#{locale}_short_name".to_sym],
      measure: epv.property_type["#{locale}_measure".to_sym],
      value: epv.get_value,
      is_binded: epv.is_binded, 
      order_number: prop_type_prod_type.nil? ? 0 : prop_type_prod_type.order_number,
      more_than: prop_type_prod_type.nil? ? nil : prop_type_prod_type.more_than,
      less_than: prop_type_prod_type.nil? ? nil : prop_type_prod_type.less_than,
      equal: prop_type_prod_type.nil? ? nil : prop_type_prod_type.equal
     }
    end
  end
  
  def full_name
    %{#{manufacturer.blank? ? "" : "#{manufacturer} "}#{name}}
  end
  
  def entity_property_values_attributes=(attrs)
    return if attrs.blank?
    to_add = []
    attrs.values.each do |v|
      pv = self.entity_property_values.find_by(property_type_id: v[:property_type_id])
      if pv.nil?
        to_add.push v
      else
        pv.update_attributes(v)
      end
    end
    self.entity_property_values.create(to_add) if !to_add.blank?
  end
  
  def self.draft(p_type)
    d = find_by(is_draft: true, product_type_id: p_type.id)
    if d.nil?
      d = p_type.products.create(is_draft: true)
      d.update_attribute(:entity_property_values_attributes, p_type.default_property_values)
    end
    return d
  end

end

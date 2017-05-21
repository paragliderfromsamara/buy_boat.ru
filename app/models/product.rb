class Product < ApplicationRecord
  belongs_to :product_type
  has_many :entity_property_values, as: :entity, dependent: :delete_all
  has_many :shop_products, dependent: :delete_all
  
  
  accepts_nested_attributes_for :entity_property_values
  
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

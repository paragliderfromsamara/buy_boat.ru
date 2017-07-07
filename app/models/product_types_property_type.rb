class ProductTypesPropertyType < ApplicationRecord
  after_create :set_default_values
  belongs_to :product_type
  belongs_to :property_type
  
  private
  def set_default_values
    products = product_type.products
    if !products.blank?
      products.each do |product|
        if product.entity_property_values.find_by(property_type_id: self.property_type.id).nil?
          product.entity_property_values.create(property_type_id: self.property_type_id, set_value: self.property_type.default_value, is_binded: false)
        end 
      end
    end
  end
end

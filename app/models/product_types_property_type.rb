class ProductTypesPropertyType < ApplicationRecord
  belongs_to :product_type
  belongs_to :property_type
end

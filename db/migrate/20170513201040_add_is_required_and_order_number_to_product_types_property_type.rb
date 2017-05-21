class AddIsRequiredAndOrderNumberToProductTypesPropertyType < ActiveRecord::Migration[5.0]
  def change
    add_column :product_types_property_types, :is_required, :boolean, default: true
    add_column :product_types_property_types, :order_number, :integer, default: 1
  end
end

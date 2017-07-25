class AddLessThanAndMoreThanAndEqualToProductTypesPropertyTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :product_types_property_types, :less_than, :integer
    add_column :product_types_property_types, :more_than, :integer
    add_column :product_types_property_types, :equal, :integer
  end
end

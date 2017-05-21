class CreateJoinTableProductTypesPropertyTypes < ActiveRecord::Migration[5.0]
  def change
    create_join_table :product_types, :property_types
  end
end

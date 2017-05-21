class AddPluralNameToProductType < ActiveRecord::Migration[5.0]
  def change
    add_column :product_types, :plural_name, :string
  end
end

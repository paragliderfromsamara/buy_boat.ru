class AddTagToProductType < ActiveRecord::Migration[5.0]
  def change
    add_column :product_types, :tag, :string
  end
end

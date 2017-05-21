class AddIsDraftToProductType < ActiveRecord::Migration[5.0]
  def change
    add_column :product_types, :is_draft, :boolean, default: :false
  end
end

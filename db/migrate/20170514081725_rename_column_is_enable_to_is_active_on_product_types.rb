class RenameColumnIsEnableToIsActiveOnProductTypes < ActiveRecord::Migration[5.0]
  def change
    rename_column :product_types, :is_enable, :is_active
  end
end

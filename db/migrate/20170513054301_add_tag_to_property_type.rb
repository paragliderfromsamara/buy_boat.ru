class AddTagToPropertyType < ActiveRecord::Migration[5.0]
  def change
    add_column :property_types, :tag, :string, default: ""
  end
end

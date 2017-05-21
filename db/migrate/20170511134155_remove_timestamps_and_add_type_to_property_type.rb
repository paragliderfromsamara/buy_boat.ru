class RemoveTimestampsAndAddTypeToPropertyType < ActiveRecord::Migration[5.0]
  def change
    remove_timestamps :property_types
    add_column :property_types, :value_type, :string, default: 'string'
    add_column :property_types, :ru_short_name, :string, default: ''
    add_column :property_types, :en_short_name, :string, default: '' 
  end
end

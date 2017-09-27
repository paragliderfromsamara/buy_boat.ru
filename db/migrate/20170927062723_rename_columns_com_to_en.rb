class RenameColumnsComToEn < ActiveRecord::Migration[5.0]
  def change
    rename_column :property_types, :com_name, :en_name
    rename_column :property_types, :com_short_name, :en_short_name
    rename_column :property_types, :com_measure, :en_measure
    rename_column :entity_property_values, :com_float_value, :en_float_value
    rename_column :entity_property_values, :com_integer_value, :en_integer_value
    rename_column :entity_property_values, :com_string_value, :en_string_value
    rename_column :entity_property_values, :com_bool_value, :en_bool_value
    
    rename_column :boat_types, :use_on_com, :use_on_en
    rename_column :boat_types, :com_description, :en_description
    rename_column :boat_types, :com_slogan, :en_slogan
  end
end

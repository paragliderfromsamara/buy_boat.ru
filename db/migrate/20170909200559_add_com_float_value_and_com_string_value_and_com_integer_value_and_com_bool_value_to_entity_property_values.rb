class AddComFloatValueAndComStringValueAndComIntegerValueAndComBoolValueToEntityPropertyValues < ActiveRecord::Migration[5.0]
  def change
    add_column :entity_property_values, :com_float_value, :float, default: 0.0
    add_column :entity_property_values, :com_integer_value, :integer, default: 0
    add_column :entity_property_values, :com_string_value, :string, default: ''
    add_column :entity_property_values, :com_bool_value, :boolean, default: true
    
    rename_column :entity_property_values, :float_value, :ru_float_value
    rename_column :entity_property_values, :integer_value, :ru_integer_value
    rename_column :entity_property_values, :string_value, :ru_string_value
    rename_column :entity_property_values, :bool_value, :ru_bool_value
  end
end

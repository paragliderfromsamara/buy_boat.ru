class RenameEnColumnsToCom < ActiveRecord::Migration[5.0]
  def change
    rename_column :property_types, :en_name, :com_name
    rename_column :property_types, :en_short_name, :com_short_name
    rename_column :property_types, :en_measure, :com_measure
  end
end

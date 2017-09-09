class RenameBoatTypeModificationNameToRuNameAndDescriptionToRuDescription < ActiveRecord::Migration[5.0]
  def change
    rename_column :boat_type_modifications, :name, :ru_name
    rename_column :boat_type_modifications, :description, :ru_description
    rename_column :boat_type_modifications, :accomodation_view, :accomodation_view_1
  end
end

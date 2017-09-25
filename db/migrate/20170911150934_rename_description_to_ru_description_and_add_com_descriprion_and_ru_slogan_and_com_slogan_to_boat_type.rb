class RenameDescriptionToRuDescriptionAndAddComDescriprionAndRuSloganAndComSloganToBoatType < ActiveRecord::Migration[5.0]
  def change
    rename_column :boat_types, :description, :ru_description
    add_column :boat_types, :com_description, :string, default: ''
    add_column :boat_types, :ru_slogan, :string, default: ''
    add_column :boat_types, :com_slogan, :string, default: ''
    remove_column :boat_types, :min_hp, :integer
    remove_column :boat_types, :max_hp, :integer
    remove_column :boat_types, :creator_id, :integer
    remove_column :boat_types, :modifier_id, :integer
    remove_column :boat_types, :base_cost, :float
    remove_column :boat_types, :hull_width, :float
    remove_column :boat_types, :hull_length, :float
  end
end

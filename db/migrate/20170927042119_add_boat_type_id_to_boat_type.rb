class AddBoatTypeIdToBoatType < ActiveRecord::Migration[5.0]
  def change
    add_column :boat_types, :boat_type_id, :integer
    add_column :boat_types, :has_modifications, :boolean, default: false
    add_column :boat_types, :bow_view, :string
    add_column :boat_types, :aft_view, :string
    add_column :boat_types, :top_view, :string
    add_column :boat_types, :accomodation_view_1, :string
    add_column :boat_types, :accomodation_view_2, :string
    add_column :boat_types, :accomodation_view_3, :string
  end
end

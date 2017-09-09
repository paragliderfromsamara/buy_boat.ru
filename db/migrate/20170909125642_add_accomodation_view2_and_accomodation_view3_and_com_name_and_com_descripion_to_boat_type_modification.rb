class AddAccomodationView2AndAccomodationView3AndComNameAndComDescripionToBoatTypeModification < ActiveRecord::Migration[5.0]
  def change
    add_column :boat_type_modifications, :accomodation_view_2, :string
    add_column :boat_type_modifications, :accomodation_view_3, :string
    add_column :boat_type_modifications, :com_name, :string, default: ''
    add_column :boat_type_modifications, :com_description, :string, default: ''
  end
end

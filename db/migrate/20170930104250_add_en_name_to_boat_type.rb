class AddEnNameToBoatType < ActiveRecord::Migration[5.0]
  def change
    add_column :boat_types, :en_name, :string
    rename_column :boat_types, :name, :ru_name
  end
end

class AddCnfDataFileUrlToBoatType < ActiveRecord::Migration[5.0]
  def change
    add_column :boat_types, :cnf_data_file_url, :string
  end
end

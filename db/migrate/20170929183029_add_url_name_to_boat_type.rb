class AddUrlNameToBoatType < ActiveRecord::Migration[5.0]
  def change
    add_column :boat_types, :url_name, :string
  end
end

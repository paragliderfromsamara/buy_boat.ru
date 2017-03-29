class AddShortNameToBoatOptionType < ActiveRecord::Migration[5.0]
  def change
    add_column :boat_option_types, :short_name, :string
  end
end

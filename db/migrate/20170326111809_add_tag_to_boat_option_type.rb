class AddTagToBoatOptionType < ActiveRecord::Migration[5.0]
  def change
    add_column :boat_option_types, :tag, :string
  end
end

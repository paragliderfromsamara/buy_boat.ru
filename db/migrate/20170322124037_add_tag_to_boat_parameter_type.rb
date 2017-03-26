class AddTagToBoatParameterType < ActiveRecord::Migration[5.0]
  def change
    add_column :boat_parameter_types, :tag, :string
  end
end

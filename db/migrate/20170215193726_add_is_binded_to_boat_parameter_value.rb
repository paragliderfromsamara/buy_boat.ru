class AddIsBindedToBoatParameterValue < ActiveRecord::Migration[5.0]
  def change
    add_column :boat_parameter_values, :is_binded, :boolean, default: false
  end
end

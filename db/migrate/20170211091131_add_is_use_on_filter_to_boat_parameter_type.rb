class AddIsUseOnFilterToBoatParameterType < ActiveRecord::Migration[5.0]
  def change
    add_column :boat_parameter_types, :is_use_on_filter, :boolean, default: false
  end
end

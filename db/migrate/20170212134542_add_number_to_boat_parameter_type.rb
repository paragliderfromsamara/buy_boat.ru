class AddNumberToBoatParameterType < ActiveRecord::Migration[5.0]
  def change
    add_column :boat_parameter_types, :number, :integer
  end
end

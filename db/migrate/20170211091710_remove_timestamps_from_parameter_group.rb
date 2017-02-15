class RemoveTimestampsFromParameterGroup < ActiveRecord::Migration[5.0]
  def change
    remove_timestamps :boat_parameter_types 
  end
end

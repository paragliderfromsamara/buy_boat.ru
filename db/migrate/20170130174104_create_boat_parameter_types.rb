class CreateBoatParameterTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :boat_parameter_types do |t|
      t.string :name
      t.string :short_name
      t.string :measure
      t.string :value_type

      t.timestamps
    end
  end
end

class CreateBoatParameterValues < ActiveRecord::Migration[5.0]
  def change
    create_table :boat_parameter_values do |t|
      t.integer :boat_type_id
      t.integer :boat_parameter_type_id
      t.boolean :bool_value
      t.integer :integer_value
      t.float :float_value
      t.string :string_value

      t.timestamps
    end
  end
end

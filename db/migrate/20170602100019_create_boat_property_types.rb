class CreateBoatPropertyTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :boat_property_types, id: false do |t|
      t.integer :property_type_id, index: true
      t.integer :order_number
    end
  end
end

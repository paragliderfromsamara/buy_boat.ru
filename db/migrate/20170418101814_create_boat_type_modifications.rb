class CreateBoatTypeModifications < ActiveRecord::Migration[5.0]
  def change
    create_table :boat_type_modifications do |t|
      t.integer :boat_type_id
      t.integer :boat_option_type_id
      t.string :name
      t.string :description
      t.boolean :is_active, default: true
      t.string :bow_view
      t.string :aft_view
      t.string :top_view
      t.string :accomodation_view
      
      t.timestamps
    end
  end
end

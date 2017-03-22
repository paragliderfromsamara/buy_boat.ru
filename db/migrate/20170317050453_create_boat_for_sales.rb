class CreateBoatForSales < ActiveRecord::Migration[5.0]
  def change
    create_table :boat_for_sales do |t|
      t.integer :boat_type_id
      t.string :note
      t.integer :discount
      t.string :discount_case
      t.string :status
      
      t.timestamps
    end
  end
end

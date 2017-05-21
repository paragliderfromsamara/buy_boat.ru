class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.integer :product_type_id
      t.string :name
      t.string :manufacturer
    
    end
  end
end

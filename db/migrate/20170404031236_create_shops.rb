class CreateShops < ActiveRecord::Migration[5.0]
  def change
    create_table :shops do |t|
      t.integer :city_id
      t.integer :manager_id
      t.string :name
      t.string :street
      t.string :request_email
      t.string :phone_number_1
      t.string :phone_number_2
      t.string :description
      t.boolean :is_opened, default: :true 
      t.boolean :is_active, default: :false
      
      t.timestamps
    end
  end
end

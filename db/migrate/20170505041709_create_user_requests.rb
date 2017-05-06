class CreateUserRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :user_requests do |t|
      t.integer :user_id
      t.integer :boat_for_sale_id
      t.integer :shop_id
      t.integer :number, default: 1
      t.integer :status, default: 0
      
      t.timestamps
    end
  end
end

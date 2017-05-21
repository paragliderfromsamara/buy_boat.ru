class CreateShopProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :shop_products do |t|
      t.references :product, index: true
      t.references :shop, index: true
      t.integer :amount, default: 0
      t.integer :request_limit, default: 1

      t.timestamps
    end
  end
end

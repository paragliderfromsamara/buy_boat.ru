class AddShopIdToBoatForSale < ActiveRecord::Migration[5.0]
  def change
    add_column :boat_for_sales, :shop_id, :integer
  end
end

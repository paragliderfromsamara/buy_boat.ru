class AddAmountToBoatForSale < ActiveRecord::Migration[5.0]
  def change
    add_column :boat_for_sales, :amount, :integer, default: 0
  end
end

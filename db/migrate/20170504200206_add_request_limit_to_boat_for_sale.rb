class AddRequestLimitToBoatForSale < ActiveRecord::Migration[5.0]
  def change
    add_column :boat_for_sales, :request_limit, :integer, default: 1
  end
end

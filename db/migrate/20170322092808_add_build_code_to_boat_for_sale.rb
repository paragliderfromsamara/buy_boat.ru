class AddBuildCodeToBoatForSale < ActiveRecord::Migration[5.0]
  def change
    add_column :boat_for_sales, :build_code, :string
  end
end

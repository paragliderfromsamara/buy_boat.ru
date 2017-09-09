class AddDesignCategoryToBoatType < ActiveRecord::Migration[5.0]
  def change
    add_column :boat_types, :design_category, :string
  end
end

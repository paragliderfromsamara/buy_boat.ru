class RemoveUpdaterIdAndCreatorIdFromTrademark < ActiveRecord::Migration[5.0]
  def change
    remove_column :trademarks, :updater_id, :creator_id
  end
end

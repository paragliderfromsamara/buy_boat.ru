class AddUseOnRuAndUseOnComToBoatTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :boat_types, :use_on_ru, :boolean, default: true
    add_column :boat_types, :use_on_com, :boolean, default: false
  end
end

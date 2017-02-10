class CreateBoatTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :boat_types do |t|
      t.string :name
      t.integer :boat_series_id
      t.integer :trademark_id
      t.string :body_type
      t.string :description
      t.float :base_cost, default: 0.0
      t.integer :min_hp, default: 30
      t.integer :max_hp, default: 40
      t.float :hull_width
      t.float :hull_length
      t.boolean :is_deprecated, default: false
      t.boolean :is_active, default: false
      t.integer :creator_id
      t.integer :modifier_id

      t.timestamps
    end
  end
end

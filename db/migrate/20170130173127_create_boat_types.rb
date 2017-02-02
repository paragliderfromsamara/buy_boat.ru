class CreateBoatTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :boat_types do |t|
      t.string :name
      t.string :series
      t.string :body_type
      t.string :description
      t.float :base_cost
      t.integer :min_hp
      t.integer :max_hp
      t.float :hull_width
      t.float :hull_length
      t.boolean :is_deprecated
      t.boolean :is_active
      t.integer :creator_id
      t.integer :modifier_id

      t.timestamps
    end
  end
end

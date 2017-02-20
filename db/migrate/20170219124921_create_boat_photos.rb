class CreateBoatPhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :boat_photos do |t|
      t.integer :boat_type_id, null: false
      t.integer :photo_id, null: false
      t.boolean :is_boat_photo, default: false
      t.string :desription, default: ""
    end
  end
end

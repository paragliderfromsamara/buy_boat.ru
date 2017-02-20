class CreatePhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :photos do |t|
      t.string :link
      t.boolean :is_slider
      t.integer :uploader_id, null: false

      t.timestamps
    end
  end
end

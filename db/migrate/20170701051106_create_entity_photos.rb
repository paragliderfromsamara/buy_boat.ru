class CreateEntityPhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :entity_photos do |t|
      t.references :entity, polymorphic: true, index: true
      t.references :photo, index: true
      t.boolean :is_main, default: :false
    end
  end
end

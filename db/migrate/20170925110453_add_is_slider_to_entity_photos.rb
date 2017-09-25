class AddIsSliderToEntityPhotos < ActiveRecord::Migration[5.0]
  def change
    add_column :entity_photos, :is_slider, :boolean, default: false
  end
end

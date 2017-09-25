json.array!(@entity.entity_photos) do |ep|
  json.extract! ep.hash_view, :id, :is_main, :is_slider, :wide_small, :wide_medium, :wide_large, :thumb, :thumb_square, :small, :medium, :large
end
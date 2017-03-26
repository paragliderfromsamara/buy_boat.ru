json.array!(@boat_types) do |boat_type|
  json.extract! boat_type, :id, :catalog_name, :body_type, :description, :base_cost, :min_hp, :max_hp, :hull_width, :hull_length
  json.url boat_type_url(boat_type, format: :json)
end

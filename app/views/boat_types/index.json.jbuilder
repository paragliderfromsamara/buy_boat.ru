json.array!(@boat_types) do |boat_type|
  json.extract! boat_type, :id, :name, :series, :body_type, :description, :base_cost, :min_hp, :max_hp, :hull_width, :hull_length, :is_deprecated, :is_active, :creator_id, :modifier_id
  json.url boat_type_url(boat_type, format: :json)
end

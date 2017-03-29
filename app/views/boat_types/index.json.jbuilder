json.array!(@boat_types) do |boat_type|
  json.extract! boat_type, :id, :catalog_name, :body_type, :description, :boat_for_sales
  json.url boat_type_url(boat_type, format: :json)
end

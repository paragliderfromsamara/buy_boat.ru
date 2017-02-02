json.array!(@boat_parameter_types) do |boat_parameter_type|
  json.extract! boat_parameter_type, :id, :name, :short_name, :measure, :value_type
  json.url boat_parameter_type_url(boat_parameter_type, format: :json)
end

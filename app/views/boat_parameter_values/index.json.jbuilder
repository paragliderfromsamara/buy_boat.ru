json.array!(@boat_parameter_values) do |boat_parameter_value|
  json.extract! boat_parameter_value, :id, :boat_type_id, :boat_parameter_type_id, :bool_value, :integer_value, :float_value, :string_value
  json.url boat_parameter_value_url(boat_parameter_value, format: :json)
end

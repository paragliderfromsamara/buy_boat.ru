json.array!(@manufacturers) do |manufacturer|
  json.extract! manufacturer, :id, :name, :www, :email, :phone, :logo, :creator_id, :updator_id
  json.url manufacturer_url(manufacturer, format: :json)
end

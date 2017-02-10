json.array!(@trademarks) do |trademark|
  json.extract! trademark, :id, :name, :www, :email, :phone, :logo, :creator_id, :updater_id
  json.url trademark_url(trademark, format: :json)
end

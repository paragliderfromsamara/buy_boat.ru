json.array!(@boat_for_sales) do |bfs|
  json.extract! bfs, :id, :amount, :build_code, :catalog_name, :alter_photo_hash
  json.url boat_for_sale_url(bfs)
end

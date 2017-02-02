json.array!(@users) do |user|
  json.extract! user, :id, :first_name, :last_name, :third_name, :email, :phone_number, :post_index, :salt, :encrypted_password, :user_type_id
  json.url user_url(user, format: :json)
end

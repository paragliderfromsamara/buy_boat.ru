# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin = User.create(email: "siteadmin@buy-boats.ru", password: "123456", password_confirmation: "123456", user_type_id: 131313)
manager = User.create(email: "manager@buy-boats.ru", password: "123456", password_confirmation: "123456", user_type_id: 100500)
customer = User.create(email: "customer@buy-boats.ru", password: "123456", password_confirmation: "123456", user_type_id: 500100)

9.times do |t|
  BoatType.create(name: "40#{t}", series: "серия-#{t}", body_type: "4#{t*10}")
end
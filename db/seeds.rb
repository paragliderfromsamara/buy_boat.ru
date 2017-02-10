# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin = User.create(first_name: "Администратор", last_name: "Администратор", email: "siteadmin@buy-boats.ru", password: "123456", password_confirmation: "123456", user_type_id: 131313)

manager = User.create(email: "manager@buy-boats.ru", password: "123456", password_confirmation: "123456", user_type_id: 100500, creator_salt: admin.salt, creator_email: admin.email)
customer = User.create(email: "customer@buy-boats.ru", password: "123456", password_confirmation: "123456", user_type_id: 500100, creator_salt: admin.salt, creator_email: admin.email)

trademarks = Trademark.create([
                                        {
                                          email: "salut@salute.com", 
                                          www: "salut-boats.ru", 
                                          name: "Салют", 
                                          creator_id: admin.id, 
                                          updater_id: admin.id
                                          },
                                          {
                                            email: "realcraft@realcraft.com", 
                                            www: "Realcraftboats.ru", 
                                            name: "Realcraft", 
                                            creator_id: admin.id, 
                                            updater_id: admin.id
                                            }
                                      ])

BoatSeries.create([
                      {
                        name: "CLASSIC",
                        description: ""
                      },
                      {
                        name: "NEXT",
                        description: ""
                      },
                      {
                        name: "PRO",
                        description: ""
                      },
                      {
                        name: "NEWLINE",
                        description: ""
                      }

                  ])

BoatSeries.all.each do |s|
  9.times do |t|
    BoatType.create(name: "1#{t}0", body_type: "4#{t*10}", boat_series_id: s.id, trademark_id: 1, creator_id: admin.id, modifier_id: admin.id)
  end
end
9.times do |t|
  BoatType.create(name: "40#{t}", body_type: "4#{t*10}", trademark_id: 2, creator_id: admin.id, modifier_id: admin.id)
end




BoatParameterType.create([
                              {
                                name: "Минимальная мощность двигателя",
                                short_name: "Мин. мощн. ПМ",
                                measure: "л.с.",
                                value_type: "integer"
                              },
                              {
                                name: "Максимальная мощность двигателя",
                                short_name: "Макс. мощн. ПМ",
                                measure: "л.с.",
                                value_type: "integer"
                              },
                              {
                                name: "Ширина корпуса",
                                measure: "мм",
                                value_type: "integer"
                              },
                              {
                                name: "Длина корпуса",
                                measure: "мм",
                                value_type: "integer"
                              },
                              {
                                name: "Длина корпуса",
                                measure: "мм",
                                value_type: "integer"
                              }
                          ])
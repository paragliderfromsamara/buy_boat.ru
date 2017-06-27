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



places = PropertyType.create(name: "Пассажировместимость {Crew limit}", short_name: "Мест {Crew limit}", measure: "чел. {pers.}", value_type: "integer")
capacity = PropertyType.create(name: "Грузоподъёмность {Max. permitted load}", measure: "кг {kg}", value_type: "integer")
max_speed = PropertyType.create(name: "Максимальная скорость {Max. speed}", measure: "км/ч {km/h}", value_type: "integer")
gliss_time = PropertyType.create(name: "t выхода в режим глиссирования при полной загрузке", measure: "с", value_type: "integer")
max_length =  PropertyType.create(name: "Длина наибольшая {Maximum length}", short_name: "Длина наиб. {Max. length}", measure: "мм {mm}", value_type: "integer")
max_width =  PropertyType.create(name: "Ширина наибольшая {Maximum beam}", short_name: "Шир. наиб. {Max. beam}", measure: "мм {mm}", value_type: "integer")
normal_width = PropertyType.create(name: "Ширина габаритная {Beam of hull}", measure: "мм {mm}", value_type: "integer")
normal_length = PropertyType.create(name: "Длина габаритная {Length of hull}", measure: "мм {mm}", value_type: "integer")
board_height = PropertyType.create(name: "Высота борта {Board height}", measure: "мм {mm}", value_type: "integer")
boat_height = PropertyType.create(name: "Высота габаритная {Boat height}", measure: "мм {mm}", value_type: "integer")
deadrise_angle = PropertyType.create(name: "Килеватость {Deadrise angle}", measure: "град. {deg}", value_type: "integer")
boat_weight = PropertyType.create(name: "Масса лодки {Empty craft mass}", measure: "кг {kg}", value_type: "integer")
transom_size = PropertyType.create(name: "Высота транца", measure: "", value_type: "option")
min_hp = PropertyType.create(name: "Минимальная мощность ПМ {Minimum engine power}", short_name: "Мин. ПМ {Min. eng. pwr}", measure: "л.с. {h.p.}", value_type: "integer")
max_hp = PropertyType.create(name: "Максимальная мощность ПМ", measure: "л.с. {h.p.}", short_name: "Макс. ПМ {Max. eng. pwr}", value_type: "integer")
recomended_hp = PropertyType.create(name: "Рекомендуемая мощность ПМ {Recomended engine power}", short_name: "Рекоменд. ПМ {Recomend. eng. pwr}", measure: "л.с. {h.p.}", value_type: "integer")

tm_salut = Trademark.create(email: "salut@salute.com", www: "salut-boats.ru", name: "Салют", creator_id: admin.id, updater_id: admin.id)
tm_real = Trademark.create(email: "realcraft@realcraft.com", www: "Realcraftboats.ru", name: "Realcraft", creator_id: admin.id, updater_id: admin.id)

classic_series = BoatSeries.create(name: "CLASSIC", description: "")
next_series = BoatSeries.create(name: "NEXT", description: "")
pro_series = BoatSeries.create(name: "PRO", description: "")
newline_series = BoatSeries.create(name: "NEWLINE", description: "")

classic_430_scout = BoatType.create(name: "SCOUT", body_type: "430", boat_series_id: classic_series.id, trademark_id: tm_salut.id, creator_id: admin.id, modifier_id: admin.id)
boat = classic_430_scout
boat.boat_parameter_values.find_by(boat_parameter_type_id: places.id).update_attributes(set_value: 5) #пассажировместимость
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_length.id).update_attributes(set_value: 4300) #длина наибольшая 
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_width.id).update_attributes(set_value: 1690) #ширина наибольшая
boat.boat_parameter_values.find_by(boat_parameter_type_id: normal_length.id).update_attributes(set_value: 4520) #длина габаритная
boat.boat_parameter_values.find_by(boat_parameter_type_id: normal_width.id).update_attributes(set_value: 1745) #ширина габаритная
boat.boat_parameter_values.find_by(boat_parameter_type_id: board_height.id).update_attributes(set_value: 675) #высота борта
boat.boat_parameter_values.find_by(boat_parameter_type_id: boat_height.id).update_attributes(set_value: 1270) #высота габаритная
boat.boat_parameter_values.find_by(boat_parameter_type_id: capacity.id).update_attributes(set_value: 450) #грузоподъемность
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_hp.id).update_attributes(set_value: 40) #макс мощность двигателя
boat.boat_parameter_values.find_by(boat_parameter_type_id: min_hp.id).update_attributes(set_value: 10) #мин мощность двигателя
boat.boat_parameter_values.find_by(boat_parameter_type_id: recomended_hp.id).update_attributes(set_value: 30) #рекомендуемая мощность двигателя
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_speed.id).update_attributes(set_value: 57) #максимальная скорость 
boat.boat_parameter_values.find_by(boat_parameter_type_id: boat_weight.id).update_attributes(set_value: 198) #масса 
boat.boat_parameter_values.find_by(boat_parameter_type_id: deadrise_angle.id).update_attributes(set_value: 6) #килеватость

classic_480 = BoatType.create(name: "", body_type: "480", boat_series_id: classic_series.id, trademark_id: tm_salut.id, creator_id: admin.id, modifier_id: admin.id)
boat = classic_480
boat.boat_parameter_values.find_by(boat_parameter_type_id: places.id).update_attributes(set_value: 5) #пассажировместимость
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_length.id).update_attributes(set_value: 4720) #длина наибольшая 
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_width.id).update_attributes(set_value: 1706) #ширина наибольшая
boat.boat_parameter_values.find_by(boat_parameter_type_id: normal_length.id).update_attributes(set_value: 5050) #длина габаритная
boat.boat_parameter_values.find_by(boat_parameter_type_id: normal_width.id).update_attributes(set_value: 1750) #ширина габаритная
boat.boat_parameter_values.find_by(boat_parameter_type_id: board_height.id).update_attributes(set_value: 740) #высота борта
boat.boat_parameter_values.find_by(boat_parameter_type_id: capacity.id).update_attributes(set_value: 500) #грузоподъемность
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_hp.id).update_attributes(set_value: 70) #макс мощность двигателя
boat.boat_parameter_values.find_by(boat_parameter_type_id: min_hp.id).update_attributes(set_value: 40) #мин мощность двигателя
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_speed.id).update_attributes(set_value: 57) #максимальная скорость 
boat.boat_parameter_values.find_by(boat_parameter_type_id: boat_weight.id).update_attributes(set_value: 322) #масса 
boat.boat_parameter_values.find_by(boat_parameter_type_id: deadrise_angle.id).update_attributes(set_value: 11) #килеватость
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_speed.id).update_attributes(set_value: 65) #максимальная скорость 

classic_480 = BoatType.create(name: "", body_type: "480", boat_series_id: classic_series.id, trademark_id: tm_salut.id, creator_id: admin.id, modifier_id: admin.id)
boat = classic_480
boat.boat_parameter_values.find_by(boat_parameter_type_id: places.id).update_attributes(set_value: 5) #пассажировместимость
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_length.id).update_attributes(set_value: 4720) #длина наибольшая 
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_width.id).update_attributes(set_value: 1706) #ширина наибольшая
boat.boat_parameter_values.find_by(boat_parameter_type_id: normal_length.id).update_attributes(set_value: 5050) #длина габаритная
boat.boat_parameter_values.find_by(boat_parameter_type_id: normal_width.id).update_attributes(set_value: 1750) #ширина габаритная
boat.boat_parameter_values.find_by(boat_parameter_type_id: board_height.id).update_attributes(set_value: 740) #высота борта
boat.boat_parameter_values.find_by(boat_parameter_type_id: capacity.id).update_attributes(set_value: 500) #грузоподъемность
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_hp.id).update_attributes(set_value: 70) #макс мощность двигателя
boat.boat_parameter_values.find_by(boat_parameter_type_id: min_hp.id).update_attributes(set_value: 40) #мин мощность двигателя
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_speed.id).update_attributes(set_value: 57) #максимальная скорость 
boat.boat_parameter_values.find_by(boat_parameter_type_id: boat_weight.id).update_attributes(set_value: 322) #масса 
boat.boat_parameter_values.find_by(boat_parameter_type_id: deadrise_angle.id).update_attributes(set_value: 11) #килеватость
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_speed.id).update_attributes(set_value: 65) #максимальная скорость

realcraft_190 = BoatType.create(name: "", body_type: "190", trademark_id: tm_real.id, creator_id: admin.id, modifier_id: admin.id)
boat = realcraft_190
boat.boat_parameter_values.find_by(boat_parameter_type_id: places.id).update_attributes(set_value: 5) #пассажировместимость
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_length.id).update_attributes(set_value: 4720) #длина наибольшая 
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_width.id).update_attributes(set_value: 1706) #ширина наибольшая
boat.boat_parameter_values.find_by(boat_parameter_type_id: normal_length.id).update_attributes(set_value: 5050) #длина габаритная
boat.boat_parameter_values.find_by(boat_parameter_type_id: normal_width.id).update_attributes(set_value: 1750) #ширина габаритная
boat.boat_parameter_values.find_by(boat_parameter_type_id: board_height.id).update_attributes(set_value: 740) #высота борта
boat.boat_parameter_values.find_by(boat_parameter_type_id: capacity.id).update_attributes(set_value: 500) #грузоподъемность
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_hp.id).update_attributes(set_value: 70) #макс мощность двигателя
boat.boat_parameter_values.find_by(boat_parameter_type_id: min_hp.id).update_attributes(set_value: 40) #мин мощность двигателя
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_speed.id).update_attributes(set_value: 57) #максимальная скорость 
boat.boat_parameter_values.find_by(boat_parameter_type_id: boat_weight.id).update_attributes(set_value: 322) #масса 
boat.boat_parameter_values.find_by(boat_parameter_type_id: deadrise_angle.id).update_attributes(set_value: 11) #килеватость
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_speed.id).update_attributes(set_value: 65) #максимальная скорость 

realcraft_200 = BoatType.create(name: "", body_type: "200", trademark_id: tm_real.id, creator_id: admin.id, modifier_id: admin.id)
boat = realcraft_200
boat.boat_parameter_values.find_by(boat_parameter_type_id: places.id).update_attributes(set_value: 5) #пассажировместимость
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_length.id).update_attributes(set_value: 4720) #длина наибольшая 
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_width.id).update_attributes(set_value: 1706) #ширина наибольшая
boat.boat_parameter_values.find_by(boat_parameter_type_id: normal_length.id).update_attributes(set_value: 5050) #длина габаритная
boat.boat_parameter_values.find_by(boat_parameter_type_id: normal_width.id).update_attributes(set_value: 1750) #ширина габаритная
boat.boat_parameter_values.find_by(boat_parameter_type_id: board_height.id).update_attributes(set_value: 740) #высота борта
boat.boat_parameter_values.find_by(boat_parameter_type_id: capacity.id).update_attributes(set_value: 500) #грузоподъемность
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_hp.id).update_attributes(set_value: 70) #макс мощность двигателя
boat.boat_parameter_values.find_by(boat_parameter_type_id: min_hp.id).update_attributes(set_value: 40) #мин мощность двигателя
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_speed.id).update_attributes(set_value: 57) #максимальная скорость 
boat.boat_parameter_values.find_by(boat_parameter_type_id: boat_weight.id).update_attributes(set_value: 322) #масса 
boat.boat_parameter_values.find_by(boat_parameter_type_id: deadrise_angle.id).update_attributes(set_value: 11) #килеватость
boat.boat_parameter_values.find_by(boat_parameter_type_id: max_speed.id).update_attributes(set_value: 65) #максимальная скорость 
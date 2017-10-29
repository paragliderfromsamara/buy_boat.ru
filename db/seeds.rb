# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin = User.create(first_name: "Администратор", last_name: "Администратор", email: "siteadmin@buy-boats.ru", password: "123456", password_confirmation: "123456", user_type_id: 131313)

manager = User.create(email: "manager@buy-boats.ru", password: "123456", password_confirmation: "123456", user_type_id: 100500)
customer = User.create(email: "customer@buy-boats.ru", password: "123456", password_confirmation: "123456", user_type_id: 500100)



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

boat_propety_types = []
i = 0
PropertyType.all.each do |pt|
  i+=1
  boat_propety_types.push({property_type_id: pt.id, order_number: i})
end
BoatPropertyType.create(boat_propety_types) if !boat_propety_types.blank?

tm_salut = Trademark.create(email: "salut@salute.com", www: "salut-boats.ru", name: "Салют", creator_id: admin.id, updater_id: admin.id)
tm_real = Trademark.create(email: "realcraft@realcraft.com", www: "Realcraftboats.ru", name: "Realcraft", creator_id: admin.id, updater_id: admin.id)

classic_series = BoatSeries.create(name: "CLASSIC", description: "")
next_series = BoatSeries.create(name: "NEXT", description: "")
pro_series = BoatSeries.create(name: "PRO", description: "")
newline_series = BoatSeries.create(name: "NEWLINE", description: "")

classic_430_scout = BoatType.create(ru_name: "430 SCOUT", body_type: "430", url_name: 'scout_430', boat_series_id: classic_series.id, trademark_id: tm_salut.id)

boat = classic_430_scout.reload.modifications.first
boat.entity_property_values.find_by(property_type_id: places.id).update_attributes(set_ru_value: 5, set_en_value: 5) #пассажировместимость
boat.entity_property_values.find_by(property_type_id: max_length.id).update_attributes(set_ru_value: 4300, set_en_value: 4300) #длина наибольшая 
boat.entity_property_values.find_by(property_type_id: max_width.id).update_attributes(set_ru_value: 1690, set_en_value: 1690) #ширина наибольшая
boat.entity_property_values.find_by(property_type_id: normal_length.id).update_attributes(set_ru_value: 4520, set_en_value: 4520) #длина габаритная
boat.entity_property_values.find_by(property_type_id: normal_width.id).update_attributes(set_ru_value: 1745, set_en_value: 1745) #ширина габаритная
boat.entity_property_values.find_by(property_type_id: board_height.id).update_attributes(set_ru_value: 675, set_en_value: 675) #высота борта
boat.entity_property_values.find_by(property_type_id: boat_height.id).update_attributes(set_ru_value: 1270, set_en_value: 1270) #высота габаритная
boat.entity_property_values.find_by(property_type_id: capacity.id).update_attributes(set_ru_value: 450, set_en_value: 450) #грузоподъемность
boat.entity_property_values.find_by(property_type_id: max_hp.id).update_attributes(set_ru_value: 40, set_en_value: 40) #макс мощность двигателя
boat.entity_property_values.find_by(property_type_id: min_hp.id).update_attributes(set_ru_value: 10, set_en_value: 10) #мин мощность двигателя
boat.entity_property_values.find_by(property_type_id: recomended_hp.id).update_attributes(set_ru_value: 30, set_en_value: 30) #рекомендуемая мощность двигателя
boat.entity_property_values.find_by(property_type_id:  max_speed.id).update_attributes(set_ru_value: 57, set_en_value: 57) #максимальная скорость 
boat.entity_property_values.find_by(property_type_id: boat_weight.id).update_attributes(set_ru_value: 198, set_en_value: 198) #масса 
boat.entity_property_values.find_by(property_type_id: deadrise_angle.id).update_attributes(set_ru_value: 6, set_en_value: 6) #килеватость

classic_480 = BoatType.create(ru_name: "480", body_type: "480", url_name: '480_classic', boat_series_id: classic_series.id, trademark_id: tm_salut.id)
boat = classic_480.reload.modifications.first
boat.entity_property_values.find_by(property_type_id: places.id).update_attributes(set_ru_value: 5) #пассажировместимость
boat.entity_property_values.find_by(property_type_id: max_length.id).update_attributes(set_ru_value: 4720) #длина наибольшая 
boat.entity_property_values.find_by(property_type_id: max_width.id).update_attributes(set_ru_value: 1706) #ширина наибольшая
boat.entity_property_values.find_by(property_type_id: normal_length.id).update_attributes(set_ru_value: 5050) #длина габаритная
boat.entity_property_values.find_by(property_type_id: normal_width.id).update_attributes(set_ru_value: 1750) #ширина габаритная
boat.entity_property_values.find_by(property_type_id: board_height.id).update_attributes(set_ru_value: 740) #высота борта
boat.entity_property_values.find_by(property_type_id: capacity.id).update_attributes(set_ru_value: 500) #грузоподъемность
boat.entity_property_values.find_by(property_type_id: max_hp.id).update_attributes(set_ru_value: 70) #макс мощность двигателя
boat.entity_property_values.find_by(property_type_id: min_hp.id).update_attributes(set_ru_value: 40) #мин мощность двигателя
boat.entity_property_values.find_by(property_type_id: max_speed.id).update_attributes(set_ru_value: 57) #максимальная скорость 
boat.entity_property_values.find_by(property_type_id: boat_weight.id).update_attributes(set_ru_value: 322) #масса 
boat.entity_property_values.find_by(property_type_id: deadrise_angle.id).update_attributes(set_ru_value: 11) #килеватость
boat.entity_property_values.find_by(property_type_id: max_speed.id).update_attributes(set_ru_value: 65) #максимальная скорость 

classic_480 = BoatType.create(ru_name: "480 CLASSIC", body_type: "480", boat_series_id: classic_series.id, trademark_id: tm_salut.id)
boat = classic_480.reload.modifications.first
boat.entity_property_values.find_by(property_type_id: places.id).update_attributes(set_ru_value: 5) #пассажировместимость
boat.entity_property_values.find_by(property_type_id: max_length.id).update_attributes(set_ru_value: 4720) #длина наибольшая 
boat.entity_property_values.find_by(property_type_id: max_width.id).update_attributes(set_ru_value: 1706) #ширина наибольшая
boat.entity_property_values.find_by(property_type_id: normal_length.id).update_attributes(set_ru_value: 5050) #длина габаритная
boat.entity_property_values.find_by(property_type_id: normal_width.id).update_attributes(set_ru_value: 1750) #ширина габаритная
boat.entity_property_values.find_by(property_type_id: board_height.id).update_attributes(set_ru_value: 740) #высота борта
boat.entity_property_values.find_by(property_type_id: capacity.id).update_attributes(set_ru_value: 500) #грузоподъемность
boat.entity_property_values.find_by(property_type_id: max_hp.id).update_attributes(set_ru_value: 70) #макс мощность двигателя
boat.entity_property_values.find_by(property_type_id: min_hp.id).update_attributes(set_ru_value: 40) #мин мощность двигателя
boat.entity_property_values.find_by(property_type_id: max_speed.id).update_attributes(set_ru_value: 57) #максимальная скорость 
boat.entity_property_values.find_by(property_type_id: boat_weight.id).update_attributes(set_ru_value: 322) #масса 
boat.entity_property_values.find_by(property_type_id: deadrise_angle.id).update_attributes(set_ru_value: 11) #килеватость
boat.entity_property_values.find_by(property_type_id: max_speed.id).update_attributes(set_ru_value: 65) #максимальная скорость

realcraft_190 = BoatType.create(ru_name: "190", body_type: "480", trademark_id: tm_real.id)
boat = realcraft_190.reload.modifications.first
boat.entity_property_values.find_by(property_type_id: places.id).update_attributes(set_ru_value: 5, set_en_value: 5) #пассажировместимость
boat.entity_property_values.find_by(property_type_id: max_length.id).update_attributes(set_ru_value: 4720, set_en_value: 4720) #длина наибольшая 
boat.entity_property_values.find_by(property_type_id: max_width.id).update_attributes(set_ru_value: 1706, set_en_value: 1706) #ширина наибольшая
boat.entity_property_values.find_by(property_type_id: normal_length.id).update_attributes(set_ru_value: 5050,set_en_value: 5050) #длина габаритная
boat.entity_property_values.find_by(property_type_id: normal_width.id).update_attributes(set_ru_value: 1750, set_en_value: 1750) #ширина габаритная
boat.entity_property_values.find_by(property_type_id: board_height.id).update_attributes(set_ru_value: 740, set_en_value: 740) #высота борта
boat.entity_property_values.find_by(property_type_id: capacity.id).update_attributes(set_ru_value: 500, set_en_value: 500) #грузоподъемность
boat.entity_property_values.find_by(property_type_id: max_hp.id).update_attributes(set_ru_value: 70, set_en_value: 70) #макс мощность двигателя
boat.entity_property_values.find_by(property_type_id: min_hp.id).update_attributes(set_ru_value: 40, set_en_value: 40) #мин мощность двигателя
boat.entity_property_values.find_by(property_type_id: max_speed.id).update_attributes(set_ru_value: 57, set_en_value: 57) #максимальная скорость 
boat.entity_property_values.find_by(property_type_id: boat_weight.id).update_attributes(set_ru_value: 322, set_en_value: 322) #масса 
boat.entity_property_values.find_by(property_type_id: deadrise_angle.id).update_attributes(set_ru_value: 11, set_en_value: 11) #килеватость
boat.entity_property_values.find_by(property_type_id: max_speed.id).update_attributes(set_ru_value: 65, set_en_value: 65) #максимальная скорость 

realcraft_200 = BoatType.create(
                                  ru_name: "200", 
                                  body_type: "490", 
                                  design_category: "C",
                                  trademark_id: tm_real.id,
                                  ru_slogan: "Cоздана для тех, кто не боится самых экстремальных метео условий",
                                  en_slogan: "Designed for people who are used to navigating in the most extreme conditions",
                                  ru_description: "Лодка RealCraft 190 предоставляет владельцу широкие возможности для всех видов отдыха на воде. Увеличенный основной кокпит, широкий проход в носовой кокпит, ровный пол, под которым большие отсеки для хранения якорей, фалов, кранцев и других вещей, предназначенные для спиннингов и удилищ полочки вдоль бортов делают RealCraft 190 отличной лодкой для увлеченного рыболова.",
                                  en_description: "Realсraft 190 can provide you a wide range of leisure activities on the water. Increased main cockpit, wide passage to the front cockpit, level floor, spacious units for storage of anchors, halyards, fenders and other things, shelves for spinning and fishing rods along the boards make Realсraft 190 a great boat for enthusiastic fishermen.",
                                  modifications_number: 2
                                )
boat = realcraft_200.reload.modifications.first
boat.update_attributes(
                        ru_name: "Pro", 
                        en_name: 'Pro',
                        ru_description: 'Версия "Pro" выпускается с прямым ветровым остеклением. Остекление может быть выполнено как из пластика, так и калёного стекла', 
                        en_description: 'PRO Version goes with the direct plastic or tempered glass'
                        )
boat.entity_property_values.find_by(property_type_id: places.id).update_attributes(set_ru_value: 5, set_en_value: 5) #пассажировместимость
boat.entity_property_values.find_by(property_type_id: max_length.id).update_attributes(set_ru_value: 4720, set_en_value: 4720) #длина наибольшая 
boat.entity_property_values.find_by(property_type_id: max_width.id).update_attributes(set_ru_value: 1706, set_en_value: 1706) #ширина наибольшая
boat.entity_property_values.find_by(property_type_id: normal_length.id).update_attributes(set_ru_value: 5050, set_en_value: 5050) #длина габаритная
boat.entity_property_values.find_by(property_type_id: normal_width.id).update_attributes(set_ru_value: 1750, set_en_value: 1750) #ширина габаритная
boat.entity_property_values.find_by(property_type_id: board_height.id).update_attributes(set_ru_value: 740, set_en_value: 740) #высота борта
boat.entity_property_values.find_by(property_type_id: capacity.id).update_attributes(set_ru_value: 500, set_en_value: 500) #грузоподъемность
boat.entity_property_values.find_by(property_type_id: max_hp.id).update_attributes(set_ru_value: 70, set_en_value: 70) #макс мощность двигателя
boat.entity_property_values.find_by(property_type_id: min_hp.id).update_attributes(set_ru_value: 40, set_en_value: 40) #мин мощность двигателя
boat.entity_property_values.find_by(property_type_id: max_speed.id).update_attributes(set_ru_value: 57, set_en_value: 57) #максимальная скорость 
boat.entity_property_values.find_by(property_type_id: boat_weight.id).update_attributes(set_ru_value: 322, set_en_value: 322) #масса 
boat.entity_property_values.find_by(property_type_id: deadrise_angle.id).update_attributes(set_ru_value: 11, set_en_value: 11) #килеватость
boat.entity_property_values.find_by(property_type_id: max_speed.id).update_attributes(set_ru_value: 65, set_en_value: 65) #максимальная скорость 

boat = realcraft_200.reload.modifications.last
boat.update_attributes(
                        ru_name: "Navi", 
                        en_name: 'Navi', 
                        ru_description: 'Модификация "Navi" выпускается с гнутым ветровым остеклением выполненным из оргстекла', 
                        en_description: 'Navi version with the curved plastic glass'
                      )
boat.entity_property_values.find_by(property_type_id: places.id).update_attributes(set_ru_value: 5, set_en_value: 5) #пассажировместимость
boat.entity_property_values.find_by(property_type_id: max_length.id).update_attributes(set_ru_value: 4720, set_en_value: 4720) #длина наибольшая 
boat.entity_property_values.find_by(property_type_id: max_width.id).update_attributes(set_ru_value: 1706, set_en_value: 1706) #ширина наибольшая
boat.entity_property_values.find_by(property_type_id: normal_length.id).update_attributes(set_ru_value: 5050, set_en_value: 5050) #длина габаритная
boat.entity_property_values.find_by(property_type_id: normal_width.id).update_attributes(set_ru_value: 1750, set_en_value: 1750) #ширина габаритная
boat.entity_property_values.find_by(property_type_id: board_height.id).update_attributes(set_ru_value: 740, set_en_value: 740) #высота борта
boat.entity_property_values.find_by(property_type_id: capacity.id).update_attributes(set_ru_value: 500, set_en_value: 500) #грузоподъемность
boat.entity_property_values.find_by(property_type_id: max_hp.id).update_attributes(set_ru_value: 70, set_en_value: 70) #макс мощность двигателя
boat.entity_property_values.find_by(property_type_id: min_hp.id).update_attributes(set_ru_value: 40, set_en_value: 40) #мин мощность двигателя
boat.entity_property_values.find_by(property_type_id: max_speed.id).update_attributes(set_ru_value: 57, set_en_value: 57) #максимальная скорость 
boat.entity_property_values.find_by(property_type_id: boat_weight.id).update_attributes(set_ru_value: 322, set_en_value: 322) #масса 
boat.entity_property_values.find_by(property_type_id: deadrise_angle.id).update_attributes(set_ru_value: 11, set_en_value: 11) #килеватость
boat.entity_property_values.find_by(property_type_id: max_speed.id).update_attributes(set_ru_value: 65, set_en_value: 65) #максимальная скорость 
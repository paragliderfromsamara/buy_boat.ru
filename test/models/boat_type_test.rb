require 'test_helper'

class BoatTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  #create_table "boat_types", force: :cascade do |t|
  #  t.string   "name"
  #  t.integer  "boat_series_id"
  #  t.integer  "trademark_id"
  #  t.string   "body_type"
  #  t.string   "description"
  # t.float    "base_cost",         default: 0.0
  #  t.integer  "min_hp",            default: 30
  #  t.integer  "max_hp",            default: 40
  #  t.float    "hull_width"
  #  t.float    "hull_length"
  #  t.boolean  "is_deprecated",     default: false
  #  t.boolean  "is_active",         default: false
  #  t.integer  "creator_id"
  #  t.integer  "modifier_id"
  #  t.datetime "created_at",                        null: false
  #  t.datetime "updated_at",                        null: false
  #  t.integer  "photo_id"
  #  t.string   "cnf_data_file_url"
  #end
  
  test "При создании типа лодки и модификации должно автоматически заполняться url_name" do
    boat_type = default_boat_type
    assert_equal "boat_type_#{boat_type.id}", boat_type.url_name, "Если экземпляр базовый тип, то url_name должен быть 'boat_type_#{boat_type.id}'"
    assert_equal "modification_#{boat_type.modifications.first.id}", boat_type.modifications.first.url_name, "Если экземпляр модификация, то url_name должен быть 'modification_#{boat_type.id}'"
  end
  
  test "При создании базового типа boat_type не должен создавать entity_property_values" do 
    boat_type = default_boat_type
    assert boat_type.save, "Не удалось сохранить тестовый тип лодки"
    boat_type.reload
    assert boat_type.entity_property_values.size == 0
  end
  
  test "Тест создания модификаций при добавлении нового типа лодки" do 
    min_number = 1
    mid_number = 3
    max_number = 5
    boat_type_min = default_boat_type
    boat_type_max = default_boat_type({modifications_number: max_number})
    boat_type_mid = default_boat_type({modifications_number: mid_number})

    assert_equal min_number, boat_type_min.modifications.size, "Без атрибута modifications_number должно быть создано #{min_number} модификаций"
    assert_equal max_number, boat_type_max.modifications.size, "Со значением modifications_number численно большим #{max_number} должно быть создано #{max_number} модификаций"
    assert_equal mid_number, boat_type_mid.modifications.size, "С допустимым значением modifications_number должно быть создано #{mid_number} модификаций"
    assert_equal 0, boat_type_min.modifications.first.modifications.size, "У модификации не должно быть модификаций"
  end
  
  test "При создании базового типа должен создавать количество модификаций указаных в атрибуте modifications_number" do 
    boat_type = default_boat_type
    assert boat_type.modifications.size == 1, 'Без атрибута modifications_number ни одной модификации добалено не было'
  end
  
  test "При создании модификации boat_type должна создаваться entity_property_values" do 
    boat_type = default_boat_type
    modification = boat_type.modifications.build
    assert modification.save, "Не удалось добавить модификацию"
    modification.reload
    assert_not BoatPropertyType.all.size == 0, "Список типов свойств для типов лодок пуст"
    assert modification.entity_property_values.size == BoatPropertyType.all.size, "При добавлении модификации, к ней должна прицепляться таблица характеристик props: #{BoatPropertyType.all.size}, entities: #{modification.entity_property_values.size}"
  end
  
  test "Тест на обновление атрибутов связей boat_series_id trademark_id, также и body_type" do
    boat_type = default_boat_type
    modification = boat_type.modifications.first
    assert modification.boat_series_id == boat_type.boat_series_id, "boat_series_id после добавления новой модификации не стал как в типе лодки"
    assert modification.trademark_id == boat_type.trademark_id, "trademark_id после добавления новой модификации не стал как в типе лодки"
    assert modification.body_type == boat_type.body_type, "body_type после добавления новой модификации не стал как в типе лодки" 
    
    
    boat_type.update_attributes(boat_series: boat_series(:two)) #, trademark: trademarks(:two), body_type: '600'
    modification.reload
    assert modification.boat_series_id == boat_type.boat_series_id, "boat_series_id модификации не обновился после обновления в типе лодки"
    
    
    boat_type.update_attributes(trademark: trademarks(:two)) #, trademark: trademarks(:two), body_type: '600'
    modification.reload
    assert modification.trademark_id == boat_type.trademark_id, "trademark_id модификации не обновился после обновления в типе лодки"
    
    boat_type.update_attributes(body_type: '600') #, trademark: trademarks(:two), body_type: '600'
    modification.reload
    assert modification.body_type == boat_type.body_type, "body_type модификации не обновился после обновления в типе лодки" 
  end
  
  
  #до 29-09-2017
  #test "Должен позволять добавлять новые типы лодки и создавать для них таблицу параметров" do
  #  boat_type = BoatType.new(
  #                            name: default_string,
  #                            ru_description: default_string,
  #                            boat_series_id: BoatSeries.first.id,
  #                            trademark_id: Trademark.first.id,
  #                            body_type: "480"
  #                          )
  #  assert boat_type.save, "Не удалось добавить новый тип лодки #{boat_type.errors.messages.first}"
  #  assert boat_type.entity_property_values.size > 0, "Таблица параметров не добавилась"
  #end
  

  test "Должен добавлять записи configurator_entities при обновлении BoatType с входящим атрибутом configurator_entities" do
    boat_types = BoatType.all.limit(3)
    assert boat_types.length > 0, "Нет ни одного BoatType для данного теста"
    boat_types.each do |boat_type|
      configurator_entities = convert_arr_to_hash(make_random_good_entities)
      assert_difference("ConfiguratorEntity.count", configurator_entities.length, "При обновлении сущностей конфигуратора, должны были создаться сущности в  configuration_entities") do 
        assert boat_type.update_attributes(configurator_entities_attributes: configurator_entities), "Не удалось обновить BoatType"
      end
    end
  end
  
  test "Должен добавлять ранее не известные boat_option_type при обновлении BoatType с входящим атрибутом configurator_entities_attributes" do
    boat_type = BoatType.first
    assert !boat_type.nil?, "Нет ни одного BoatType для данного теста"
    opts = make_random_good_entities
    opt_with_cod_count = 0
    opts.each {|opt| opt_with_cod_count += 1 if !opt[:param_code].blank? } # option_boat_type должна добавляться при условии, что у нее есть param_code
    configurator_entities = convert_arr_to_hash(opts)
    assert_difference("BoatOptionType.count", opt_with_cod_count, "При обновлении сущностей конфигуратора, должны были создаться сущности в boat_option_type") do 
      assert boat_type.update_attributes(configurator_entities_attributes: configurator_entities), "Не удалось обновить BoatType"
    end
    boat_type.reload
    addOpts = make_random_good_entities(false, opts.last[:arr_id]+1) #дополнительные опции без стандарта
    opt_with_cod_count = 0
    addOpts.each {|opt| opt_with_cod_count += 1 if !opt[:param_code].blank? } 
    opts += addOpts
    configurator_entities = convert_arr_to_hash(opts)
    assert_difference("BoatOptionType.count", opt_with_cod_count, "При обновлении сущностей конфигуратора, должны были создаться ранее не существующие сущности в boat_option_type") do 
      assert boat_type.update_attributes(configurator_entities_attributes: configurator_entities), "Не удалось обновить BoatType"
    end
    boat_type.reload
    assert_no_difference("BoatOptionType.count", "При обновлении сущностей конфигуратора, не должны добавляться уже существующие в boat_option_type") do 
      assert boat_type.update_attributes(configurator_entities_attributes: configurator_entities), "Не удалось обновить BoatType"
    end
  end
  
  private
  
  def default_boat_type(add_hash = {})
    default = {name: default_string,
                              boat_series_id: BoatSeries.first.id,
                              trademark_id: Trademark.first.id,
                              body_type: "480",
                              design_category: 'C'
              }
    default.merge! add_hash
    boat_type = BoatType.new(default)
    assert boat_type.save, "Не удалось сохранить тестовый тип лодки"
    return  boat_type.reload
  end
  
  def convert_arr_to_hash(arr) #преобразует массив ['a', 'b', 'c'] в хэш вида {'0' => 'a', '1' => 'b', '2' => 'c' }
    ents = {}
    i = -1
    arr.each {|e| ents[(i+=1).to_s.to_sym] = e}
    return ents
  end
  
end

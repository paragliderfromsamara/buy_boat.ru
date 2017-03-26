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
  test "Должен позволять добавлять новые типы лодки" do
    boat_type = BoatType.new(
                              name: default_string,
                              description: default_string,
                              boat_series_id: BoatSeries.first.id,
                              trademark_id: Trademark.first.id,
                              body_type: "480",
                              modifier_id: users(:admin).id,
                              creator_id: users(:admin).id
                            )
    assert boat_type.save, "Не удалось добавить новый тип лодки #{boat_type.errors.messages.first}"
  end

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
  
  def convert_arr_to_hash(arr) #преобразует массив ['a', 'b', 'c'] в хэш вида {'0' => 'a', '1' => 'b', '2' => 'c' }
    ents = {}
    i = -1
    arr.each {|e| ents[(i+=1).to_s.to_sym] = e}
    return ents
  end
  
end

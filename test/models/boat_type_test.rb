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

  
end

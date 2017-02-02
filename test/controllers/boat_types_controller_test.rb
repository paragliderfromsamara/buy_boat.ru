require 'test_helper'

class BoatTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @boat_type = boat_types(:one)
  end

  test "should get index" do
    get boat_types_url
    assert_response :success
  end

  test "should get new" do
    get new_boat_type_url
    assert_response :success
  end

  test "should create boat_type" do
    assert_difference('BoatType.count') do
      post boat_types_url, params: { boat_type: { base_cost: @boat_type.base_cost, body_type: @boat_type.body_type, creator_id: @boat_type.creator_id, description: @boat_type.description, hull_length: @boat_type.hull_length, hull_width: @boat_type.hull_width, is_active: @boat_type.is_active, is_deprecated: @boat_type.is_deprecated, max_hp: @boat_type.max_hp, min_hp: @boat_type.min_hp, modifier_id: @boat_type.modifier_id, name: @boat_type.name, series: @boat_type.series } }
    end

    assert_redirected_to boat_type_url(BoatType.last)
  end

  test "should show boat_type" do
    get boat_type_url(@boat_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_boat_type_url(@boat_type)
    assert_response :success
  end

  test "should update boat_type" do
    patch boat_type_url(@boat_type), params: { boat_type: { base_cost: @boat_type.base_cost, body_type: @boat_type.body_type, creator_id: @boat_type.creator_id, description: @boat_type.description, hull_length: @boat_type.hull_length, hull_width: @boat_type.hull_width, is_active: @boat_type.is_active, is_deprecated: @boat_type.is_deprecated, max_hp: @boat_type.max_hp, min_hp: @boat_type.min_hp, modifier_id: @boat_type.modifier_id, name: @boat_type.name, series: @boat_type.series } }
    assert_redirected_to boat_type_url(@boat_type)
  end

  test "should destroy boat_type" do
    assert_difference('BoatType.count', -1) do
      delete boat_type_url(@boat_type)
    end

    assert_redirected_to boat_types_url
  end
end

require 'test_helper'

class BoatParameterTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @boat_parameter_type = boat_parameter_types(:one)
  end

  test "should get index" do
    get boat_parameter_types_url
    assert_response :success
  end

  test "should get new" do
    get new_boat_parameter_type_url
    assert_response :success
  end

  test "should create boat_parameter_type" do
    assert_difference('BoatParameterType.count') do
      post boat_parameter_types_url, params: { boat_parameter_type: { measure: @boat_parameter_type.measure, name: @boat_parameter_type.name, short_name: @boat_parameter_type.short_name, value_type: @boat_parameter_type.value_type } }
    end

    assert_redirected_to boat_parameter_type_url(BoatParameterType.last)
  end

  test "should show boat_parameter_type" do
    get boat_parameter_type_url(@boat_parameter_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_boat_parameter_type_url(@boat_parameter_type)
    assert_response :success
  end

  test "should update boat_parameter_type" do
    patch boat_parameter_type_url(@boat_parameter_type), params: { boat_parameter_type: { measure: @boat_parameter_type.measure, name: @boat_parameter_type.name, short_name: @boat_parameter_type.short_name, value_type: @boat_parameter_type.value_type } }
    assert_redirected_to boat_parameter_type_url(@boat_parameter_type)
  end

  test "should destroy boat_parameter_type" do
    assert_difference('BoatParameterType.count', -1) do
      delete boat_parameter_type_url(@boat_parameter_type)
    end

    assert_redirected_to boat_parameter_types_url
  end
end

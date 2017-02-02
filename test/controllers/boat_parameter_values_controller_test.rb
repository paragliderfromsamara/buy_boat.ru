require 'test_helper'

class BoatParameterValuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @boat_parameter_value = boat_parameter_values(:one)
  end

  test "should get index" do
    get boat_parameter_values_url
    assert_response :success
  end

  test "should get new" do
    get new_boat_parameter_value_url
    assert_response :success
  end

  test "should create boat_parameter_value" do
    assert_difference('BoatParameterValue.count') do
      post boat_parameter_values_url, params: { boat_parameter_value: { boat_parameter_type_id: @boat_parameter_value.boat_parameter_type_id, boat_type_id: @boat_parameter_value.boat_type_id, bool_value: @boat_parameter_value.bool_value, float_value: @boat_parameter_value.float_value, integer_value: @boat_parameter_value.integer_value, string_value: @boat_parameter_value.string_value } }
    end

    assert_redirected_to boat_parameter_value_url(BoatParameterValue.last)
  end

  test "should show boat_parameter_value" do
    get boat_parameter_value_url(@boat_parameter_value)
    assert_response :success
  end

  test "should get edit" do
    get edit_boat_parameter_value_url(@boat_parameter_value)
    assert_response :success
  end

  test "should update boat_parameter_value" do
    patch boat_parameter_value_url(@boat_parameter_value), params: { boat_parameter_value: { boat_parameter_type_id: @boat_parameter_value.boat_parameter_type_id, boat_type_id: @boat_parameter_value.boat_type_id, bool_value: @boat_parameter_value.bool_value, float_value: @boat_parameter_value.float_value, integer_value: @boat_parameter_value.integer_value, string_value: @boat_parameter_value.string_value } }
    assert_redirected_to boat_parameter_value_url(@boat_parameter_value)
  end

  test "should destroy boat_parameter_value" do
    assert_difference('BoatParameterValue.count', -1) do
      delete boat_parameter_value_url(@boat_parameter_value)
    end

    assert_redirected_to boat_parameter_values_url
  end
end

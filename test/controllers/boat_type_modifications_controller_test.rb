require 'test_helper'

class BoatTypeModificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get boat_type_modifications_edit_url
    assert_response :success
  end

  test "should get update" do
    get boat_type_modifications_update_url
    assert_response :success
  end

end

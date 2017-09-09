require 'test_helper'

class RealcraftControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get realcraft_index_url
    assert_response :success
  end

  test "should get about" do
    get realcraft_about_url
    assert_response :success
  end

  test "should get prices" do
    get realcraft_prices_url
    assert_response :success
  end

  test "should get dealers" do
    get realcraft_dealers_url
    assert_response :success
  end

  test "should get boat" do
    get realcraft_boat_url
    assert_response :success
  end

end

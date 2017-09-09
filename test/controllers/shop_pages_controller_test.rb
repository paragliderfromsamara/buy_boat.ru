require 'test_helper'

class ShopPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get shop_pages_index_url
    assert_response :success
  end

  test "should get boats" do
    get shop_pages_boats_url
    assert_response :success
  end

  test "should get shops" do
    get shop_pages_shops_url
    assert_response :success
  end

end

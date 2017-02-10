require 'test_helper'

class TrademarksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @trademark = trademarks(:one)
  end

  test "should get index" do
    get trademarks_url
    assert_response :success
  end

  test "should get new" do
    get new_trademark_url
    assert_response :success
  end

  test "should create trademark" do
    assert_difference('Trademark.count') do
      post trademarks_url, params: { trademark: { creator_id: @trademark.creator_id, email: @trademark.email, logo: @trademark.logo, name: @trademark.name, phone: @trademark.phone, updater_id: @trademark.updater_id, www: @trademark.www } }
    end

    assert_redirected_to trademark_url(Trademark.last)
  end

  test "should show trademark" do
    get trademark_url(@trademark)
    assert_response :success
  end

  test "should get edit" do
    get edit_trademark_url(@trademark)
    assert_response :success
  end

  test "should update trademark" do
    patch trademark_url(@trademark), params: { trademark: { creator_id: @trademark.creator_id, email: @trademark.email, logo: @trademark.logo, name: @trademark.name, phone: @trademark.phone, updater_id: @trademark.updater_id, www: @trademark.www } }
    assert_redirected_to trademark_url(@trademark)
  end

  test "should destroy trademark" do
    assert_difference('Trademark.count', -1) do
      delete trademark_url(@trademark)
    end

    assert_redirected_to trademarks_url
  end
end

require 'test_helper'

class ManufacturersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manufacturer = manufacturers(:one)
  end

  test "should get index" do
    get manufacturers_url
    assert_response :success
  end

  test "should get new" do
    get new_manufacturer_url
    assert_response :success
  end

  test "should create manufacturer" do
    assert_difference('Manufacturer.count') do
      post manufacturers_url, params: { manufacturer: { creator_id: @manufacturer.creator_id, email: @manufacturer.email, logo: @manufacturer.logo, name: @manufacturer.name, phone: @manufacturer.phone, updator_id: @manufacturer.updator_id, www: @manufacturer.www } }
    end

    assert_redirected_to manufacturer_url(Manufacturer.last)
  end

  test "should show manufacturer" do
    get manufacturer_url(@manufacturer)
    assert_response :success
  end

  test "should get edit" do
    get edit_manufacturer_url(@manufacturer)
    assert_response :success
  end

  test "should update manufacturer" do
    patch manufacturer_url(@manufacturer), params: { manufacturer: { creator_id: @manufacturer.creator_id, email: @manufacturer.email, logo: @manufacturer.logo, name: @manufacturer.name, phone: @manufacturer.phone, updator_id: @manufacturer.updator_id, www: @manufacturer.www } }
    assert_redirected_to manufacturer_url(@manufacturer)
  end

  test "should destroy manufacturer" do
    assert_difference('Manufacturer.count', -1) do
      delete manufacturer_url(@manufacturer)
    end

    assert_redirected_to manufacturers_url
  end
end

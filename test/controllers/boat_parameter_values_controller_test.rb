require 'test_helper'

class BoatParameterValuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @password = default_string
    @white_list_for_modify = ["admin"]
    @white_list_for_unbind = ["admin"]
    @users = default_users(@password)
  end
  
  
  
  test "Тест на возможность пользования функционалом зарегестрированными пользователями" do
    @users.each do |u|
      s = login(u.email)
      s.visit_switch_bind_page(u)
      s.visit_update_page(u)
      s.sign_out
    end
  end
  
  test "Тест на возможность пользования функционалом НЕзарегестрированными пользователями" do
     guest = guest_visit
     guest.visit_as_guest_test
  end
  
  private
  
  module CustomDsl
    def sign_out
      get signout_path
    end
    
    def visit_switch_bind_page(u) #boat_parameter_values#switch_bind
      parameter = BoatParameterType.create(name: default_string, short_name: default_string, value_type: "string")
      value = parameter.boat_parameter_values.first
      bind_before = value.is_binded
      is_good = !@white_list_for_unbind.index(u.user_type).nil?
      get switch_bind_parameter_value_path id: value.id, boat_type_id: value.boat_type_id, xhr: true
      if is_good
        assert_response :success, "#{u.user_type} не удалось пройти на страницу rebind"
        assert_equal @response.body, {status: :ok}.to_json, "#{u.user_type} должен увидеть ok в случае успешности запроса"
        value.reload
        assert_not_equal bind_before, value.is_binded, "#{u.user_type} не удалось переключить флаг is_binded" 
      else
        assert_redirected_to "/404", "#{u.user_type} удалось пройти на страницу rebind"
      end
    end
    
    def visit_update_page(u) #boat_parameter_values#switch_bind
      parameter = BoatParameterType.create(name: default_string, short_name: default_string, value_type: "string")
      value = parameter.boat_parameter_values.first
      is_good = !@white_list_for_unbind.index(u.user_type).nil?
      new_value = default_string
      put boat_parameter_value_path id: value.id, params: {boat_parameter_value: {set_value: new_value}}, xhr: true, format: :json
      if is_good
        assert_response :success, "#{u.user_type} не удалось отправить запрос на страницу обновления значения параметра"
        assert_equal @response.body, {status: :ok, new_value: new_value}.to_json, "#{u.user_type} не смог обновить значение параметра"
      else
        assert_redirected_to "/404", "#{u.user_type} удалось пройти на страницу rebind"
      end
    end
    
    def visit_as_guest_test
      parameter = BoatParameterType.create(name: default_string, short_name: default_string, value_type: "string")
      value = parameter.boat_parameter_values.first

    
      get switch_bind_parameter_value_path id: value.id, boat_type_id: value.boat_type_id, xhr: true
      assert_redirected_to "/404", "Гость не был переадресован на no_page при посещении switch_bind экшна"
    
      new_value = default_string
      put boat_parameter_value_path id: value.id, params: {boat_parameter_value: {set_value: new_value}}, xhr: true, format: :json
      assert_redirected_to "/404", "Гость не был переадресован на no_page при посещении update экшна"
    end
    
  end

  def guest_visit
    open_session do |sess|
      sess.extend(CustomDsl)
      sess.get "/signout"
    end
  end
  
  def login(email)
    open_session do |sess|
      sess.extend(CustomDsl)
      #sess.https!
      sess.post sessions_path, params: { session: {email: email.downcase, password: @password } }
      sess.follow_redirect!
      assert_equal my_path, sess.path, message: "Не удалось произвести вход на сайт при тесте boat_parameter_values_controller"
      #sess.https!(false)
    end
  end
end

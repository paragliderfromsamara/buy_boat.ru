require 'test_helper'

class BoatParameterTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @password = default_string
    @white_list_for_index = ["admin"]
    @white_list_for_create = ["admin"]
    @white_list_for_modify = ["admin"]
    @white_list_for_destroy = ["admin"]
    @users = default_users(@password)
  end
  
  test "Тест на возможность пользования функционалом зарегестрированными пользователями" do
    @users.each do |u|
      s = login(u.email)
      s.visit_index(u)
      s.visit_new(u)
      s.visit_create(u)
      s.visit_edit(u)
      s.visit_update(u)
      s.visit_update_numbers(u)
      s.visit_destroy(u)
      s.sign_out
    end
  end
  
  test "Тест на возможность пользования функционалом НЕ зарегестрированными пользователями" do
    guest = guest_visit
    guest.visit_index
    guest.visit_new
    guest.visit_create
    guest.visit_edit
    guest.visit_update
    guest.visit_update_numbers
    guest.visit_destroy
  end
  private
  
  module CustomDsl
    def sign_out
      get signout_path
    end
    
    def visit_index(u=nil)
      user_type = u.nil? ? "guest" : u.user_type
      is_good = u.nil? ? false : !@white_list_for_create.index(u.user_type).nil?
      get boat_parameter_types_path
      if is_good
        assert_response :success, "#{user_type} НЕ смог зайти на страницу со списком всех параметров"
      else
        assert_redirected_to "/404", "#{user_type} не был переадресован от страницы со списком всех параметров"
      end
    end
    
    def visit_new(u=nil)
      user_type = u.nil? ? "guest" : u.user_type
      is_good = u.nil? ? false : !@white_list_for_create.index(u.user_type).nil?
      get new_boat_parameter_type_path
      if is_good
        assert_response :success, "#{user_type} НЕ смог зайти на страницу со списком всех параметров"
      else
        assert_redirected_to "/404", "#{user_type} не был переадресован от страницы со списком всех параметров"
      end
    end
    
    def visit_create(u=nil)
      user_type = u.nil? ? "guest" : u.user_type
      is_good = u.nil? ? false : !@white_list_for_create.index(u.user_type).nil?
      if is_good
        assert_difference("BoatParameterType.count", 1, "#{user_type} не удалось добавить тип параметра") do
          post boat_parameter_types_path, params: {boat_parameter_type: {name: default_string, short_name: default_string, measure: default_string, value_type: "string", is_user_on_filter: false}}
        end
        assert_equal "Turbolinks.visit(window.location);", @response.body,  "#{user_type} НЕ смог зайти на страницу со списком всех параметров"
      else
        assert_no_difference("BoatParameterType.count", "#{user_type} удалось добавить тип параметра") do
          post boat_parameter_types_path, params: {boat_parameter_type: {name: default_string, short_name: default_string, measure: default_string, value_type: "string", is_user_on_filter: false}}
        end
        assert_redirected_to "/404", "#{user_type} не был переадресован от страницы со списком всех параметров"
      end
    end
    
    def visit_edit(u=nil)
      user_type = u.nil? ? "guest" : u.user_type
      is_good = u.nil? ? false : !@white_list_for_modify.index(u.user_type).nil?
        get edit_boat_parameter_type_path id: BoatParameterType.all.first.id
      if is_good
        assert_response :success, "#{user_type} НЕ смог зайти на страницу со списком всех параметров"
      else
        assert_redirected_to "/404", "#{user_type} не был переадресован от страницы со списком всех параметров"
      end
    end
    
    def visit_update(u=nil)
      new_values = {name: default_string, short_name: default_string, measure: default_string}
      user_type = u.nil? ? "guest" : u.user_type
      is_good = u.nil? ? false : !@white_list_for_modify.index(u.user_type).nil?
      type = BoatParameterType.all.last
      put boat_parameter_type_path id: type.id, params: {boat_parameter_type: new_values}
      if is_good
        assert_equal "Turbolinks.visit(window.location);", @response.body, "#{user_type} НЕ смог обновить"
        type.reload
        assert_equal type[:name], type.name, "#{user_type} НЕ обновил тип параметра"
      else
        assert_redirected_to "/404", "#{user_type} не был переадресован от страницы со списком всех параметров"
      end
    end
    
    def visit_update_numbers(u=nil)
      user_type = u.nil? ? "guest" : u.user_type
      is_good = u.nil? ? false : !@white_list_for_modify.index(u.user_type).nil?
      new_values = BoatParameterType.all.map {|t| t.number}
      new_values.shuffle!
      vals = {}
      i = 0
      BoatParameterType.all.reorder("id ASC").each do |t|
        vals["number_#{t.id}".to_sym] = new_values[i]
        i+=1
      end
     
      post "/reorder_boat_parameter_types", params: vals, xhr: true
      if is_good
        assert_equal ({status: :ok}.to_json), @response.body, "#{user_type} НЕ смог обновить нумерацию"
        assert_equal new_values.last, BoatParameterType.all.reload.reorder("id ASC").last.number, "#{user_type} НЕ обновил номер параметра"
        assert_equal new_values.first, BoatParameterType.all.reload.reorder("id ASC").first.number, "#{user_type} НЕ обновил номер параметра"
      else
        assert_not_equal ({status: :ok}.to_json), @response.body, "#{user_type} смог обновить нумерацию"
      end
    end
    
    def visit_destroy(u=nil)
      new_values = {name: default_string, short_name: default_string, measure: default_string}
      user_type = u.nil? ? "guest" : u.user_type
      is_good = u.nil? ? false : !@white_list_for_modify.index(u.user_type).nil?
      type = BoatParameterType.all.last
      if is_good
        assert_difference("BoatParameterType.count", -1, "#{user_type} НЕ смог удалить тип параметра ") do
          delete boat_parameter_type_path id: type.id, xhr: true
        end
        assert_equal "Turbolinks.visit(window.location);", @response.body, "#{user_type} получил неверный ответ сервера"
      else
        assert_no_difference("BoatParameterType.count", "#{user_type} смог удалить тип параметра ") do 
          delete boat_parameter_type_path id: type.id, xhr: true
        end
      end
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

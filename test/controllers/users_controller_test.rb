require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @default_password = default_string
    @user = users(:one)
    @manager = User.create(email: "#{default_string}@test.com", password: @default_password, password_confirmation: @default_password, creator_salt: users(:manager).salt, creator_email: users(:manager).email, user_type_id:100500)
    @customer = User.create(email: "#{default_string}@test.com", password: @default_password, password_confirmation: @default_password)
    
  end

  test "Тест просмотра страниц users_controller для пользователя Guest" do
    u = guest_visit
    
    u.visit_index
    
    u.visit_show_page(@manager)
    u.visit_show_page(@customer)
    
    u.visit_edit_page(@manager)
    u.visit_edit_page(@customer)
    
    u.do_update(@manager)
    u.do_update(@customer)
    
    u.do_destroy(@manager)
    u.do_destroy(@customer)
    
    u.visit_new(true)
    u.do_create(true)
  end
  
  
  test "Тест просмотра страниц users_controller для пользователя Manager" do 
    customer_for_delete = User.create(email: "#{default_string}@test.com", password: @default_password, password_confirmation: @default_password)
    manager_for_delete = User.create(email: "#{default_string}@test.com", password: @default_password, password_confirmation: @default_password, creator_salt: users(:manager).salt, creator_email: users(:manager).email, user_type_id:100500)
    m = login(@manager.email, @default_password)
    
    m.visit_index(true)
    
    m.visit_show_page(@manager, true, "свою")
    m.visit_show_page(users(:manager), true, "чужую")
    m.visit_show_page(@customer, true)
    
    m.visit_edit_page(@customer, true)
    m.visit_edit_page(@manager, true, "свою")
    m.visit_edit_page(users(:manager), true, "чужого")
    
    m.do_update(@customer, true)
    m.do_update(@manager, true, "свой")
    m.do_update(users(:manager), false, "чужой")
    
    m.do_destroy(manager_for_delete, false)
    m.do_destroy(customer_for_delete, true)
    m.do_destroy(@manager, true)
  end

  
  private

      module CustomDsl
        def browses_site
          get root_path
          assert_response :success, "Не удалось зайти на сайт"
        end
        
        def visit_index(could_visit = false)
          get users_path
          if could_visit
            assert_response :success, "Не удалось посмотреть страницу с пользователями"
          else
            assert_redirected_to root_path, "Удалось посмотреть страницу с пользователями"
          end
        end
        
        def visit_show_page(user, could_visit = false, m = "чужую")
          get user_path(user)
          if could_visit
            assert_response :success, "Не удалось посмотреть #{m} страницу пользователя #{user.user_type}"
          else
            assert_redirected_to root_path, "Удалось посмотреть #{m} страницу пользователя #{user.user_type}"
          end
        end
        
        def visit_edit_page(user, could_visit = false, m = "чужого")
          get edit_user_path(user)
          if could_visit
            assert_response :success, "Не удалось посмотреть страницу редактирования #{m} аккаунта #{user.user_type}"
          else
            assert_redirected_to root_path, "Удалось посмотреть страницу редактирования #{m} аккаунта #{user.user_type}"
          end
        end
        
        def do_update(user, could_visit = false, m="чужой")
          red_link = could_visit ? (m=="чужой" ? user_path(user) : my_path) : root_path
          new_names = {first_name: default_string, last_name: default_string}
          put user_path(user), params: {user: new_names}
          if could_visit
            assert_equal User.find_by(email: user.email).first_name, new_names[:first_name], message: "Не удалось обновить #{m} аккаунт #{user.user_type}"
          else
            assert_not_equal User.find_by(email: user.email).first_name, new_names[:first_name], message: "Удалось обновить #{m} аккаунт #{user.user_type}"
          end
          assert_redirected_to red_link, "Переадресации на #{red_link} не произошло"
        end
      
        def do_create(could_visit = false)
          user_data = {email: %{#{default_string}@test_mail.com}.downcase, first_name: default_string, last_name: default_string, password: @default_password, password_confirmation: @default_password}
          count_before = User.count
          post users_path, params: {user: user_data}
          if could_visit
            assert_not_nil User.find_by(email: user_data[:email].downcase)
            #assert_difference 'User.count', 1, "Не удалось зарегистрировать новый аккаунт #{flash[:alert]}" do
            #  post users_path, params: {user: user_data}
            #end
          else
            assert_nil User.find_by(email: user_data[:email].downcase)
            #assert_no_difference 'User.count', "Удалось зарегистрировать новый аккаунт" do
            #  post users_path, params: {user: user_data}
            #end
          end
        end
        
        def do_destroy(user, could_visit = false, m="чужой")
          red_link = could_visit ? my_path : root_path
          if could_visit
            assert_difference 'User.count', -1, "#{m} аккаунт должен быть удален" do
              delete user_path(user)
            end
          else
            assert_no_difference 'User.count', "#{m} аккаунт не должен быть удален" do
              delete user_path(user)
            end
          end
        end
        
        def visit_new(could_visit = false)
          get new_user_path
          if could_visit
            assert_response :success, "Не удалось зайти на страницу регистрации"
          else
            assert_redirected_to my_path, "Не был переадресован на страницу своего аккаунта"
          end
        end
        
      end
      def guest_visit
        open_session do |sess|
          sess.extend(CustomDsl)
        end
      end
      
      def login(email, password)
        open_session do |sess|
          sess.extend(CustomDsl)
          #sess.https!
          sess.post sessions_path, params: { session: {email: email.downcase, password: password } }
          sess.follow_redirect!
          assert_equal my_path, sess.path, message: "#{sess.flash[:alert]}"
          #sess.https!(false)
        end
      end
end

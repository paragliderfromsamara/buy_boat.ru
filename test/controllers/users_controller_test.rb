require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @default_password = default_string
    @manager = User.create(email: "#{default_string}@test.com", password: @default_password, password_confirmation: @default_password, creator_salt: users(:admin).salt, creator_email: users(:admin).email, user_type_id:users(:manager).user_type_id)
    @customer = User.create(email: "#{default_string}@test.com", password: @default_password, password_confirmation: @default_password)
    @banned = User.create(email: "#{default_string}@test.com", password: @default_password, password_confirmation: @default_password, creator_salt: users(:admin).salt, creator_email: users(:admin).email, user_type_id:users(:banned).user_type_id)
    @admin = User.create(email: "#{default_string}@test.com", password: @default_password, password_confirmation: @default_password, creator_salt: users(:admin).salt, creator_email: users(:admin).email, user_type_id:users(:admin).user_type_id)
    @admin_2 = User.create(email: "#{default_string}@test.com", password: @default_password, password_confirmation: @default_password, creator_salt: users(:admin).salt, creator_email: users(:admin).email, user_type_id:users(:admin).user_type_id)
    @manager_2 = User.create(email: "#{default_string}@test.com", password: @default_password, password_confirmation: @default_password, creator_salt: users(:admin).salt, creator_email: users(:admin).email, user_type_id:users(:manager).user_type_id)
  end

  test "Тест просмотра страниц users_controller для пользователя Guest" do
    u = guest_visit
    u.visit_index
    
    u.visit_show_page(users(:admin))
    u.visit_show_page(@manager)
    u.visit_show_page(@customer)
    u.visit_show_page(users(:banned))

    u.visit_edit_page(users(:admin))
    u.visit_edit_page(@manager)
    u.visit_edit_page(@customer)
    u.visit_edit_page(users(:banned))
    
    u.do_update(users(:admin))
    u.do_update(@manager)
    u.do_update(@customer)
    u.do_update(users(:banned))
    
    u.do_destroy(users(:admin))
    u.do_destroy(@manager)
    u.do_destroy(@customer)
    u.do_destroy(users(:banned))
    
    u.visit_new(true, my_path)
    u.do_create(true, my_path)
  end
  
  
  test "Тест просмотра страниц users_controller для пользователя Manager" do 
    assert_equal @manager.user_type_id, users(:manager).user_type_id
    manager_for_delete = users(:destroy_test_manager)
    customer_for_delete = users(:destroy_test_customer)
    admin_for_delete = users(:destroy_test_admin)
    banned_for_delete = users(:destroy_test_banned)
    m = login(@manager.email, @default_password)
    
    m.visit_index(true)
    
    m.visit_new(false, my_path)
    m.do_create(false, my_path)
    
    m.visit_show_page(@manager, true, "свою")
    m.visit_show_page(users(:manager), true)
    m.visit_show_page(users(:customer), true)
    m.visit_show_page(users(:admin), true)
    m.visit_show_page(users(:banned), true)
    
    m.visit_edit_page(@manager, true, "свою")
    m.visit_edit_page(users(:manager))
    m.visit_edit_page(users(:admin))
    m.visit_edit_page(users(:banned))
    m.visit_edit_page(users(:customer))
    
    m.do_update(@manager, true, "свой")
    m.do_update(users(:customer))
    m.do_update(users(:manager))
    m.do_update(users(:admin))
    m.do_update(users(:banned))
    
    m.do_destroy(manager_for_delete)
    m.do_destroy(customer_for_delete)
    m.do_destroy(admin_for_delete)
    m.do_destroy(banned_for_delete)
    m.do_destroy(@manager, true, "свой")
    

  end

  test "Тест просмотра страниц users_controller для пользователя Customer" do 
    assert_equal @customer.user_type_id, users(:customer).user_type_id
    manager_for_delete = users(:destroy_test_manager)
    customer_for_delete = users(:destroy_test_customer)
    admin_for_delete = users(:destroy_test_admin)
    banned_for_delete = users(:destroy_test_banned)
    c = login(@customer.email, @default_password)
    
    c.visit_index(false)
    
    c.visit_new(false, my_path)
    c.do_create(false, my_path)
    
    c.visit_show_page(@customer, true, "свою")
    c.visit_show_page(users(:customer))
    c.visit_show_page(users(:manager))
    c.visit_show_page(users(:admin))
    c.visit_show_page(users(:banned))
    
    c.visit_edit_page(@customer, true, "свою")
    c.visit_edit_page(users(:manager))
    c.visit_edit_page(users(:admin))
    c.visit_edit_page(users(:banned))
    c.visit_edit_page(users(:customer))
    
    c.do_update(@customer, true, "свой")
    c.do_update(users(:manager))
    c.do_update(users(:admin))
    c.do_update(users(:banned))
    c.do_update(users(:customer))
    
    c.do_destroy(manager_for_delete)
    c.do_destroy(customer_for_delete)
    c.do_destroy(admin_for_delete)
    c.do_destroy(banned_for_delete)
    c.do_destroy(@customer, true, "свой")
    

  end
  
  test "Тест просмотра страниц users_controller для пользователя Banned" do
    assert_equal @banned.user_type_id, users(:banned).user_type_id 
    manager_for_delete = users(:destroy_test_manager)
    customer_for_delete = users(:destroy_test_customer)
    admin_for_delete = users(:destroy_test_admin)
    banned_for_delete = users(:destroy_test_banned)
    c = login(@banned.email, @default_password)
    
    c.visit_index(false)
    
    c.visit_new(false, my_path)
    c.do_create(false, my_path)
    
    c.visit_show_page(@banned, true, "свою")
    c.visit_show_page(users(:manager))
    c.visit_show_page(users(:banned))
    c.visit_show_page(users(:admin))
    c.visit_show_page(users(:customer))
    
    c.visit_edit_page(@banned, false, "свою")
    c.visit_edit_page(users(:manager))
    c.visit_edit_page(users(:admin))
    c.visit_edit_page(users(:banned))
    c.visit_edit_page(users(:customer))
    
    c.do_update(@banned, false, "свой")
    c.do_update(users(:manager))
    c.do_update(users(:admin))
    c.do_update(users(:banned))
    c.do_update(users(:customer))
    
    c.do_destroy(manager_for_delete)
    c.do_destroy(customer_for_delete)
    c.do_destroy(admin_for_delete)
    c.do_destroy(banned_for_delete)
    c.do_destroy(@banned, false, "свой")
    

  end
  
  test "Тест просмотра страниц users_controller для пользователя Admin" do
    assert_equal @admin.user_type_id, users(:admin).user_type_id 
    manager_for_delete = users(:destroy_test_manager)
    customer_for_delete = users(:destroy_test_customer)
    admin_for_delete = users(:destroy_test_admin)
    banned_for_delete = users(:destroy_test_banned)
    c = login(@admin.email, @default_password)
    
    c.visit_index(true)
    
    c.visit_new(true)
    c.do_create(true, "user_page")
    
    c.visit_show_page(@admin, true, "свою")
    c.visit_show_page(users(:manager), true)
    c.visit_show_page(users(:banned), true)
    c.visit_show_page(users(:admin), true)
    c.visit_show_page(users(:customer), true)
    
    c.visit_edit_page(@admin, true, "свою")
    c.visit_edit_page(users(:manager), true)
    c.visit_edit_page(users(:admin), false)
    c.visit_edit_page(users(:banned), true)
    c.visit_edit_page(users(:customer), true)
    
    c.do_update(@admin, true, "свой")
    c.do_update(users(:manager), true)
    c.do_update(users(:admin), false)
    c.do_update(users(:banned), true)
    c.do_update(users(:customer), true)
    
    
    
    c.do_destroy(manager_for_delete, true)
    c.do_destroy(customer_for_delete, true)
    c.do_destroy(admin_for_delete, false)
    c.do_destroy(banned_for_delete, true)
    c.do_destroy(@admin, true, "свой")
    

  end
  
  test "Для Admin при создании/редактировании пользователя должны добавляться скрытые поля creator_email и creator_salt" do
    admin = login @admin_2.email, @default_password
    guest = guest_visit
    admin.check_creator_salt_email_salt_and_user_type_id(1)
    guest.check_creator_salt_email_salt_and_user_type_id(0)
  end
  
  private

      module CustomDsl
        
        def check_creator_salt_email_salt_and_user_type_id(idx = 0)
          get signup_path
          assert_response :success, "Не удалось зайти на страницу регистрации"
          assert_select "input#user_creator_salt", idx, message: "#{ "Не " if idx == 0}найдено поле input#user_creator_salt"
          assert_select "input#user_creator_email", idx,  message: "#{ "Не " if idx == 0}найдено поле input#user_creator_email"
          assert_select "select#user_user_type_id", idx, message: "#{ "Не " if idx == 0}найдено поле select#user_user_type_id"
        end
        
        def browses_site
          get root_path
          assert_response :success, "Не удалось зайти на сайт"
        end
        
        def visit_index(could_visit = false)
          get users_path
          if could_visit
            assert_response :success, "Не удалось посмотреть страницу с пользователями"
          else
            assert_redirected_to  "/404", "Удалось посмотреть страницу с пользователями"
          end
        end
        
        def visit_show_page(user, could_visit = false, m = "чужую")
          get user_path(user)
          if could_visit
            assert_response :success, "Не удалось посмотреть #{m} страницу пользователя #{user.user_type}"
          else
            assert_redirected_to "/404", "Удалось посмотреть #{m} страницу пользователя #{user.user_type}"
          end
        end
        
        def visit_edit_page(user, could_visit = false, m = "чужого")
          get edit_user_path(user)
          if could_visit
            assert_response :success, "Не удалось посмотреть страницу редактирования #{m} аккаунта #{user.user_type}"
          else
            assert_redirected_to "/404", "Удалось посмотреть страницу редактирования #{m} аккаунта #{user.user_type}"
          end
        end
        
        def do_update(user, could_visit = false, m="чужой")
          red_link = could_visit ? (m=="чужой" ? user_path(user) : my_path) :  "/404"
          new_names = {first_name: default_string, last_name: default_string}
          put user_path(user), params: {user: new_names}
          user.reload
          if could_visit
            assert_equal user.first_name, new_names[:first_name], message: "Не удалось обновить #{m} аккаунт #{user.user_type}"
          else
            assert_not_equal user.first_name, new_names[:first_name], message: "Удалось обновить #{m} аккаунт #{user.user_type}"
          end
          assert_redirected_to red_link, "Переадресации на #{red_link} не произошло"
        end
      
        def do_create(could_visit = false, url =  "/404")
          user_data = {email: rand_email, first_name: default_string, last_name: default_string, password: @default_password, password_confirmation: @default_password}
          message = ""
          if could_visit
            assert_difference 'User.count', 1, "Не удалось зарегистрировать новый аккаунт #{flash[:alert]}" do
              post users_url, params: {user: user_data}
            end
            url = (url == "user_page") ? user_path(User.last) : url 
            message = "Не удалось перейти на страницу пользовалея группой #{User.last.user_type} по адресу  #{url}"
          else
            assert_no_difference 'User.count', "Удалось зарегистрировать новый аккаунт" do
              post users_url, params: {user: user_data}
            end
          end
          assert_redirected_to url, message 
        end
        
        def do_destroy(user, could_visit = false, m="чужой")
          red_link = could_visit ? my_path : "/404"
          if could_visit
            assert_difference 'User.count', -1, "#{m} аккаунт должен быть удален" do
              delete user_path(user)
            end
          else
            assert_no_difference 'User.count', "#{m} аккаунт не должен быть удален у пользователя #{user.user_type}" do
              delete user_path(user)
            end
          end
        end
        
        def visit_new(could_visit = false, url = nil)
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
          sess.get "/signout"
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

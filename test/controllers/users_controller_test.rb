require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @default_password = default_string
    #@users_for_actions = @users_for_another_destroy = @users_for_self_destroy = @users_for_update = {}
    @users_for_self_destroy = create_users_list(@default_password)
    @users_for_actions = create_users_list(@default_password)
    @users_for_another_destroy = create_users_list(@default_password)
  end
  
  test "Тест механизма для восстановления пароля" do
    flunk("Необходимо сделать восстановления пароля пользователем")
  end
  
  #test "" do
  #  flunk("Необходимо сделать восстановления пароля пользователем")
  #end
  
  test "Тест создания пользователей для тестирования" do 
    assert @users_for_self_destroy.values.size == User.user_types.size, "Количество пользователей для удаления себя не соответствует ожиданию"
    assert @users_for_another_destroy.values.size == User.user_types.size, "Количество пользователей для которых будет удалять другой чувак не соответствует ожиданию"
    assert @users_for_actions.values.size == User.user_types.size, "Количество пользователей для тестирования экшнов не соответствует ожиданию"


    User.user_types.each do |t|
        assert_equal @users_for_self_destroy[t[:name].to_sym].user_type_id, t[:id], "Не удалось выставить верный user_type_id для пользователя группы #{t[:name]} того кто будет удалять себя"  
        assert_equal @users_for_another_destroy[t[:name].to_sym].user_type_id, t[:id], "Не удалось выставить верный user_type_id для пользователя группы #{t[:name]} того которого будет удалять другой"  
        assert_equal @users_for_actions[t[:name].to_sym].user_type_id, t[:id], "Не удалось выставить верный user_type_id для пользователя группы #{t[:name]} того которого будет делать хуйню"  
    end
  end 
  
  test "Тест на посещение страницы удаления своего аккаунта" do 
    @users_for_self_destroy.values.each do |u|
      s = login(u.email, @default_password)
      s.do_destroy(u, u.user_type != "banned", 'Свой')
    end
  end
  
  test "Тест на посещение страницы удаления чужого аккаунта" do 
    @users_for_actions.values.each do |u|
      s = login(u.email, @default_password)
      test_usrs = create_users_list(@default_password)
      test_usrs.values.each do |w|
        s.do_destroy(w, u.user_type == "admin" && w.user_type != "admin", "чужой", u.user_type)
      end
      s.sign_out
    end
  end
  
  test "Тест на посещение чужого аккаунта" do 
    test_usrs = create_users_list(@default_password)
    @users_for_actions.values.each do |u|
      s = login(u.email, @default_password)
      test_usrs.values.each do |w|
        s.visit_show_page(w, u.user_type == "admin" || u.user_type == "manager", "чужой")
      end
      s.sign_out
    end
  end
  
  test "Тест на посещение своего аккаунта" do 
    @users_for_actions.values.each do |u|
      s = login(u.email, @default_password)
      s.visit_show_page(u, true, "свою")
      s.sign_out
    end
  end
  
  test "Тест на посещение страницы редактирования своего аккаунта" do 
    @users_for_actions.values.each do |u|
      s = login(u.email, @default_password)
      s.visit_edit_page(u, u.user_type != "banned", "своего")
      s.sign_out
    end
  end
  
  test "Тест на посещение страницы редактирования чужого аккаунта" do 
    test_usrs = create_users_list(@default_password)
    @users_for_actions.values.each do |u|
      s = login(u.email, @default_password)
      test_usrs.values.each do |w|
        s.visit_edit_page(w, u.user_type == "admin" && w.user_type != "admin" , "чужого")
      end
      s.sign_out
    end
  end
  
  test "Тест на посещение страницы списка пользователей" do 
    @users_for_actions.values.each do |u|
      s = login(u.email, @default_password)
      s.visit_index(u.user_type == "admin" || u.user_type == "manager", u.user_type)
      s.sign_out
    end
  end
  
  test "Тест на посещение страницы регистрации нового пользователя и на возможность его создания" do 
    @users_for_actions.values.each do |u|
      s = login(u.email, @default_password)
      s.visit_new(u.user_type == "admin" , my_path)
      s.do_create(u.user_type == "admin" , u.user_type == "admin" ? "user_page" : my_path)
      s.sign_out
    end
  end
  
  test "Тест на обновление чужого аккаунта" do 
    @users_for_actions.values.each do |u|
      test_usrs = create_users_list(@default_password)
      s = login(u.email, @default_password)
      test_usrs.values.each do |w|
        s.do_update(w, u.user_type == "admin" && w.user_type != "admin")
      end
      s.sign_out
    end
  end
  
  test "Тест на обновление своего аккаунта" do 
    test_usrs = create_users_list(@default_password)
    test_usrs.values.each do |u|
      s = login(u.email, @default_password)
        s.do_update(u, u.user_type != "banned", "свой")
      s.sign_out
    end
  end
  
  test "Тест идентификации аккауна и проверки email адреса через action check" do
    test_usrs = create_users_list(@default_password)
    just_signup_test_user = User.create(email: "#{default_string}@test.com", password: @default_password, password_confirmation: @default_password)
    g_session = guest_visit
    signed_session = login test_usrs[:customer].email, @default_password 
    
    g_session.visit_check("Гость")
    g_session.visit_check("Гость", nil, just_signup_test_user.email)
    g_session.visit_check("Гость", just_signup_test_user.athority_mail_key)
    g_session.visit_check("Гость", just_signup_test_user.athority_mail_key, test_usrs[:customer].email)
    g_session.visit_check("Гость", just_signup_test_user.athority_mail_key, just_signup_test_user.email, true)
    
    signed_session.visit_check("#{test_usrs[:customer].user_type}")
    signed_session.visit_check("#{test_usrs[:customer].user_type}", nil, test_usrs[:customer].email)
    signed_session.visit_check("#{test_usrs[:customer].user_type}", test_usrs[:customer].athority_mail_key)
    signed_session.visit_check("#{test_usrs[:customer].user_type}", test_usrs[:customer].athority_mail_key, just_signup_test_user.email)
    signed_session.visit_check("#{test_usrs[:customer].user_type}", test_usrs[:customer].athority_mail_key, test_usrs[:customer].email, true)
  end
  
  test "Тест просмотра страниц users_controller для пользователя Guest" do
    u = guest_visit
    test_usrs = create_users_list(@default_password)
    u.visit_index
    test_usrs.values.each do |user| 
      u.visit_show_page(user)
      u.visit_edit_page(user)
      u.do_update(user)
      u.do_destroy(user)
    end   
     
    u.visit_new(true, my_path)
    u.do_create(true, my_path)
  end
  
  
  test "Для Admin при создании/редактировании пользователя должны добавляться скрытые поля creator_email и creator_salt" do
    users = create_users_list(@default_password)
    admin = login users[:admin].email, @default_password
    guest = guest_visit
    admin.check_creator_salt_email_salt_and_user_type_id(1)
    guest.check_creator_salt_email_salt_and_user_type_id(0)
  end
  
  private

      module CustomDsl
        def sign_out
          get signout_path
        end
        
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
        
        def visit_index(could_visit = false, user_type = "")
          get users_path
          if could_visit
            assert_response :success, "Не удалось посмотреть страницу с пользователями пользователю #{user_type}"
          else
            assert_redirected_to  "/404", "Удалось посмотреть страницу с пользователями пользователю #{user_type}"
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
            assert_select "#user_email", 0, message: "На странице изменения общих параметров не должно быть поля email"
            assert_select "#user_control_password", 0, message: "На странице изменения общих параметров не должно быть поля для контрольного пароля"
            assert_select "#user_password", 0, message: "На странице изменения общих параметров не должно быть поля для пароля"
            assert_select "#user_password_confirmation", 0, message: "На странице изменения общих параметров не должно быть поля для подтверждения пароля"
            #редактирование пароля
            get edit_user_path(id: user.id, update_type: "password")
            assert_response :success, "Не удалось посмотреть страницу редактирования #{m} пароля"
            assert_select "#user_control_password", 1, message: "На странице изменения пароля должно быть поле для контрольного пароля"
            assert_select "#user_password", 1, message: "На странице изменения пароля должно быть поле для пароля"
            assert_select "#user_password_confirmation", 1, message: "На странице изменения пароля должно быть поле для подтверждения пароля"
            assert_select "#user_update_type", 1, message: "На странице изменения пароля должно быть полe update_type"
            assert_select "#user_email", 0, message: "На странице изменения пароля не должно быть поля email"
            assert_select "#user_first_name", 0, message: "На странице изменения пароля не должно быть поля вторичных параметров"
            assert_select "#user_last_name", 0, message: "На странице изменения пароля не должно быть поля вторичных параметров"
            #редактирование email адреса
            get edit_user_path(id: user.id, update_type: "email")
            assert_response :success, "Не удалось посмотреть страницу редактирования #{m} пароля"
            assert_select "#user_control_password", 1, message: "На странице изменения email должно быть поле для контрольного пароля"
            assert_select "#user_update_type", 1, message: "На странице изменения email адреса должно быть полe update_type"
            assert_select "#user_email", 1, message: "На странице изменения email должно быть поле email"
            assert_select "#user_first_name", 0, message: "На странице изменения email не должно быть поля вторичных параметров"
            assert_select "#user_last_name", 0, message: "На странице изменения общих параметров не должно быть поля вторичных параметров"
            assert_select "#user_password", 0, message: "На странице изменения email не должно быть поля для пароля"
            assert_select "#user_password_confirmation", 0, message: "На странице изменения email не должно быть поле для подтверждения пароля"
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
            #обновление вторичной информации
            assert_equal user.first_name, new_names[:first_name], message: "Не удалось обновить #{m} аккаунт #{user.user_type}"
            #обновление email адреса
            p_was = user.encrypted_password
            e_was = user.email
            new_password = default_string
            new_mail = rand_email
            
            put user_path(user), params: {user: {email: new_mail, first_name: default_string, last_name: default_string, password: new_password, password_confirmation: new_password}}
           
            follow_redirect!
            user.reload
            #get root_path
            assert_equal p_was, user.encrypted_password, message: "Удалось обновить пароль без отправки контрольного пароля аккаунта #{user.user_type} "
            assert_equal e_was, user.email, message: "Удалось обновить email без отправки контрольного пароля аккаунта #{user.user_type} "
            
            put user_path(user), params: {user: {email: new_mail , control_password: default_string, update_type: "email"}}
            assert_response :success
            assert_select "#user_control_password", 1, message: "На отрендеренной странице при ошибке изменения email должно быть поле для контрольного пароля"
            assert_select "#user_email", 1, message: "На отрендеренной странице при ошибке изменения email должно быть поле email"
            assert_select "#user_first_name", 0, message: "На отрендеренной странице при ошибке изменения email  не должно быть поля вторичных параметров"
            assert_select "#user_last_name", 0, message: "На отрендеренной странице при ошибке изменения email не должно быть поля вторичных параметров"
            assert_select "#user_password", 0, message: "На отрендеренной странице при ошибке изменения email не должно быть поля для пароля"
            
            put user_path(user), params: {user: {password: default_string, password_confirmation: default_string,control_password: default_string, update_type: "password"}}
            assert_response :success
            assert_select "#user_control_password", 1, message: "На отрендеренной странице при ошибке изменения password должно быть поле для контрольного пароля"
            assert_select "#user_password", 1, message: "На отрендеренной странице при ошибке изменения password должно быть поле для пароля"
            assert_select "#user_password_confirmation", 1, message: "На отрендеренной странице при ошибке изменения password должно быть поле для подтверждения пароля"
            assert_select "#user_email", 0, message: "На отрендеренной странице при ошибке изменения password не должно быть поля email"
            assert_select "#user_first_name", 0, message: "На отрендеренной странице при ошибке изменения password  не должно быть поля вторичных параметров"
            assert_select "#user_last_name", 0, message: "На отрендеренной странице при ошибке изменения password не должно быть поля вторичных параметров"
            
            put user_path(user), params: {user: {email: new_mail , control_password: @default_password, update_type: "email"}}
            user.reload
            follow_redirect!
            assert_equal p_was, user.encrypted_password, message: "Удалось обновить пароль без отправки контрольного пароля аккаунта #{user.user_type}"
            assert_equal user.email, new_mail.downcase, message: "Не удалось обновить email c правильным контрольным паролем #{user.user_type} #{user.errors.full_messages}"
            
            put user_path(user), params: {user: {email: new_mail , control_password: @default_password, update_type: "password"}}
            user.reload
            #follow_redirect!
            assert_equal p_was, user.encrypted_password, message: "Удалось обновить пароль без отправки контрольного пароля аккаунта #{user.user_type}"
            assert_equal user.email, new_mail.downcase, message: "Не удалось обновить email c правильным контрольным паролем #{user.user_type} #{user.errors.full_messages}"
            
          
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
            user = User.last
            url = (url == "user_page") ? user_path(user) : url 
            message = "Не удалось перейти на страницу пользовалея группой #{User.last.user_type} по адресу  #{url}"
            
            welcome_mail = ActionMailer::Base.deliveries.last
            assert_equal "Проверка учётной записи", welcome_mail.subject, message: "Заголовок отправленного письма не верный"
            assert_equal user.email, welcome_mail.to[0], message: "Заголовок отправленного письма не верный"
          else
            assert_no_difference 'User.count', "Удалось зарегистрировать новый аккаунт" do
              post users_url, params: {user: user_data}
            end
          end
          assert_redirected_to url, message 
          assert_equal "Аккаунт успешно зарегестрирован, на электронный адрес #{user.email} отправлено проверочное письмо", flash[:notice] if could_visit
        end
        
        def do_destroy(user, could_visit = false, m="чужой", user_type="")
          red_link = could_visit ? my_path : "/404"
          if could_visit
            assert_difference 'User.count', -1, "#{m} аккаунт должен быть удален пользователем #{user_type}" do
              delete user_path(user)
            end
          else
            assert_no_difference 'User.count', "#{m} аккаунт не должен быть удален пользователем #{user_type}" do
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
         
        def visit_check(user_type, key=nil, email=nil, is_going_change=false)
          user = email.nil? ? nil : User.find_by(email: email.downcase)
          is_checked_email_was = user.nil? ? nil : user.is_checked_email
          get check_user_path params: {key: key, email: email}
          if key.nil? or email.nil? or user.is_checked_email
            assert_redirected_to "/404", "#{user_type}. Не произошла переадресация при отсутствующих входных параметрах для пользоватея #{user_type}"
          else
            assert_not user.nil?, "#{user_type}. Пользователь с указанным email не найден"
            user.reload
            flag = is_checked_email_was != user.is_checked_email
            if is_going_change
              assert flag, message: "#{user_type}. Флаг должен был измениться со значения #{is_checked_email_was} на #{user.is_checked_email}"
              assert_redirected_to my_path, "#{user_type}. После изменения пользователь должен быть перенаправлена на свою страницу"
              assert_equal flash[:notice], "E-mail успешно подтверждён", message: "#{user_type} увидел хуету"
            else
              assert_not flag, message: "#{user_type}. Флаг НЕ должен был измениться со значения #{is_checked_email_was} на #{user.is_checked_email}"
              assert_redirected_to "/404", "#{user_type}. Если флаг не был изменен по причине его положительного состояния, то должен быть перенаправлен на /404"
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

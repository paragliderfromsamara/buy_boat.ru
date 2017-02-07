require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do 
    @psw = "#{default_numb.to_s}"
    @ses_test_user_name = "session_test_user_name"
    User.user_types.each {|t| User.create(email: rand_email, password: @psw, password_confirmation: @psw, creator_email: users(:admin).email, creator_salt: users(:admin).salt, first_name: @ses_test_user_name, user_type_id: t[:id])}
    @users = User.where(first_name: @ses_test_user_name)
  end
  
  test "Тестирование процесса входа/выхода на сайт" do
    assert_equal @users.size, User.user_types.size, "Пользователи для тестирования сессии не создались"
    @users.each do |u| 
     s = session_test(u)
     s.leaving_site(u.user_type)
    end

  end

  private 
  
  module CustomDsl
    def leaving_site(user_type)
      get signout_path
      assert_redirected_to root_path, "После выхода с сайта пользователь типа #{user_type} не был переадресован на главную"
      get my_path
      assert_redirected_to signin_path, "Вышедший пользователь типа #{user_type} смог зайти на свою страницу"
      follow_redirect!
      assert_select "#session_email", 1, "Не найдено поле для ввода email адреса"
      assert_select "#session_password", 1, "Не найдено поле для ввода пароля"
    end
  end
  
  def session_test(user)
    open_session do |sess|
      sess.extend(CustomDsl)
      #sess.https!
      get signin_path
      assert_response :success, "Не удалось зайти на страницу входа на сайт пользователю #{user.user_type}"
      assert_select "#session_email", 1, "Не найдено поле для ввода email адреса"
      assert_select "#session_password", 1, "Не найдено поле для ввода пароля"
      sess.post sessions_path, params: { session: {email: user.email.upcase, password: "#{default_numb}" } }
      assert_equal "Неверный email или пароль", sess.flash[:alert], "Некорректное сообщение при неверном пароле"
      assert_select "#session_email", 1, "Не найдено поле для ввода email адреса"
      assert_select "#session_password", 1, "Не найдено поле для ввода пароля"
      sess.post sessions_path, params: { session: {email: user.email.upcase, password: @psw } }
      sess.follow_redirect!
      assert_equal my_path, sess.path, message: "Не удалось зайти на сайт #{sess.flash[:alert]}"
      #sess.https!(false)
    end
  end
end

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do 
    @mail_authority_test_user = User.create(email: %{#{default_string}@fuckyou.com}, password: "123456", password_confirmation: "123456")
    @psw = "123456" #пароль по умолчанию
  end
  
  test "Тест на добавление тест юзеров" do
    password = default_string
    users = default_users(password)
    flag = true
    User.user_types.each do |t|
      users.each {|u| break if (flag = u.user_type_id == t[:id])}
      break if !flag
    end
    assert_equal User.user_types.size, users.size,  "Добавилось не достаточное количество тест пользователей"
    assert flag, "Не все типы пользоваетелей добавились"
  end
  
  test "Тест сохранения сохранения пароля" do
    user = User.new(email: %{#{default_string}@fuckyou.com}, password: "123456", password_confirmation: "123456")
    assert user.save, "Тест пользователь не сохранился"
    assert !user.encrypted_password.blank? && !user.salt.blank?, "Пароль не зашифровался"
    user = User.new(email: %{#{default_string}@fuckyou.com}, password: "#{default_numb}", password_confirmation: "#{default_numb}")
    assert_not user.save, "Удалось сохранить пользователя с неправельным подтверждением"
    user = User.new(email: %{#{default_string}@fuckyou.com})
    assert_not user.save, "Удалось добавить пользователя без пароля"
  end
  
  test "Тест обновления пароля" do
    psw_1 = "#{default_numb}"
    psw_2 = "#{default_numb}"
    user = User.new(email: %{#{default_string}@fuckyou.com}, password: psw_1, password_confirmation: psw_1)
    assert user.save, "Тест пользователь не сохранился"
    salt = user.salt
    e_psw = user.encrypted_password
    assert_not user.update_attributes(password: psw_2, password_confirmation: psw_2), "Удалось изменить пароль без ввода прежнего пароля"
    assert e_psw == user.encrypted_password, "Зашифрованный пароль обновился"
   
    assert_not user.update_attributes(password: psw_2, password_confirmation: psw_2, control_password: default_numb.to_s), "Удалось изменить пароль введя неправильный прежний пароль"
    assert e_psw == user.encrypted_password, "Зашифрованный пароль обновился"
    
    assert user.update_attributes(password: psw_2, password_confirmation: psw_2, control_password: psw_1), "Не удалось изменить пароль введя правильный прежний пароль"
    assert_not e_psw == user.encrypted_password, "Зашифрованный пароль не обновился"
  end
  
  test "Тест правильности email адреса при создании пользователя" do
    bad_mail = default_string
    good_mail = %{#{default_string}@fuckyou.com}
    psw = default_numb.to_s
    u = User.new(password: psw, password_confirmation: psw, email: bad_mail)
    assert_not u.save, "удалось сохранить email неверного формата #{bad_mail}"
    u = User.new(password: psw, password_confirmation: psw, email: good_mail)
    assert u.save, "не удалось сохранить email верного формата #{good_mail}"
    assert u.email == good_mail.downcase, "перед добавлением в БД почтовый адрес не преобразуется в нижний регистр"
    assert_not u.is_checked_email, "Флаг проверенности email адреса должен быть установлен в false при создании"    
  end
  
  test "Тест обновления email адреса" do
    mail_1 = %{#{default_string}@fuckyou.com}
    mail_2 = %{#{default_string}@fuckyou.com}
    psw = default_numb.to_s
    
    u_1 = User.new(password: psw, password_confirmation: psw, email: mail_1)
    assert u_1.save, "Тест пользователь 1 не сохранился"
    
    u_2 = User.new(password: psw, password_confirmation: psw, email: mail_2)
    assert u_2.save,  "Тест пользователь 2 не сохранился"

    assert_not u_2.update_attributes(email: mail_1, control_password: psw), "Удалось обновить адрес электронной почты на адрес другого пользователя"
    
    
  
  
  end
  
  test "Тест обновления вторичных атрибутов адреса на уже существующий" do
    User.all.each {|u| update_secondary_attributes(u)}
  end
  
  test "Тест обновления email адреса без пароля пользователя" do 
    #mail_1 = %{#{default_string}@fuckyou.com}.downcase
    #mail_2 = %{#{default_string}@fuckyou.com}.downcase
    #psw = default_numb.to_s
    #fpsw = default_numb.to_s
    #u = User.new(password: psw, password_confirmation: psw, email: mail_1)
    #assert u.save, "Тест пользователь не сохранился" 
   # assert u.update_attributes(first_name: 'ffrrff', last_name: 'ffrrff', third_name: 'ffrrff'), message: "Не удалось обновить вторичные параметры 1"
    #u.reload 
    #assert_equal mail_1, u.email, message: "Удалось при сохранении вторичных данных сохранить измененный email"
    
    #assert_not u.update_attributes(email: mail_2, update_type: "email"), message: "Удалось изменить email без подтверждения паролем"
    #u.reload
   
    #assert u.update_attributes(email: mail_2, first_name: 'ffrrfferere', control_password: psw), message: "Не удалось обновить вторичные параметры, при введенном пароле 2"
    #u.reload 
    #assert_equal mail_1, u.email, message: "Удалось при сохранении вторичных данных и подтверждающем пароле сохранить измененный email"
  end
  
  test "Тест уникальности пользователя" do
    good_mail = %{#{default_string}@fuckyou.com}
    psw = default_numb.to_s
    u = User.new(password: psw, password_confirmation: psw, email: good_mail)
    u.save
    u = User.new(password: psw, password_confirmation: psw, email: good_mail)
    assert_not u.save, "Удалось сохранить два одинаковых E-Mail - а #{good_mail}"
  end
  
  test "Проверка отображения роли пользователя" do 
    m = users(:manager)
    c = users(:customer)
    b = users(:banned)
    a = users(:admin)
    assert c.user_type == "customer", "Имя 'customer' указанное в тесте, не соответствует имени полученному из модели #{c.user_type}" 
    assert m.user_type == "manager", "Имя 'manager' указанное в тесте, не соответствует имени полученному из модели #{m.user_type}"
    assert a.user_type == "admin", "Имя 'customer' указанное в тесте, не соответствует имени полученному из модели #{a.user_type}" 
    assert b.user_type == "banned", "Имя 'manager' указанное в тесте, не соответствует имени полученному из модели #{b.user_type}" 
  end
  
  test "Тест на установку user_type_id при создании нового пользователя" do
    whoes_set = whoms_set = users(:admin, :manager, :customer, :banned)
    whoes_set.each do |i_set|
      #тест добавления пользователя без информации о создателе
      set_user_type_on_create_without_creator_info_test(i_set)
      whoms_set.each do |i_change|
        #тест добавления пользователя с информацией о создателе
        set_user_type_on_create_with_creator_info_test(i_set, i_change, i_set.user_type == "admin")
      end
    end
    u = User.create(email: %{#{default_string}@fuckyou.com}, password: @psw, password_confirmation: @psw)
    assert u.user_type_id == User.default_user_type_id, "user_type_id установленный по умолчанию #{u.user_type_id} не равен User.default_user_type_id = #{User.default_user_type_id}"

  end
  
  test "Тест на установку user_type_id при обновлении пользователя" do
    updaters = updaded_usrs = users(:admin, :manager, :customer, :banned)
    m = users(:manager)
    c = users(:customer)
    a = users(:admin)
    b = users(:banned)
    psw = default_numb.to_s
    u = User.create(email: %{#{default_string}@fuckyou.com}, password: psw, password_confirmation: psw)
    
    updaters.each do |updater|
      updaded_usrs.each do |updaded|
        set_user_type_id_on_update(updater, updaded, updater.user_type == "admin")
      end
    end
    
    u.update_attributes(user_type_id: m.user_type_id, creator_email: m.email, creator_salt: m.salt, password: nil)
    assert_not_equal u.reload.user_type_id, m.user_type_id, "Удалось обновить user_type_id пользователя на произвольный user_type_id = #{m.user_type_id} с данными пользователя manager" 
  
    u.update_attributes(user_type_id: a.user_type_id, creator_email: nil, creator_salt: nil, password: nil)
    assert_not_equal u.reload.user_type_id, a.user_type_id, "Удалось обновить user_type_id на другой #{a.user_type_id}" 
    
    u = User.create(email: %{#{default_string}@fuckyou.com}, user_type_id: b.user_type_id, password: psw, password_confirmation: psw, creator_email: a.email, creator_salt: a.salt)
    
    u.update_attributes(user_type_id: c.user_type_id, creator_email: m.email, creator_salt: m.salt, password: nil)
    assert_equal u.reload.user_type_id, b.user_type_id, "User_type_id не должен сбрасываться при обновлении пользователем не имеющим прав"
    
  end
  
  test "Тест функций athority_mail_key и self.athority_mail(key, r_email)" do
    control_string = secure_hash("#{ @mail_authority_test_user.salt}--#{@mail_authority_test_user.email}--#{@mail_authority_test_user.created_at}")
    assert_equal @mail_authority_test_user.athority_mail_key, control_string, "athority_mail_key не соответсвует контрольному"  
    
    assert_equal User.athority_mail(@mail_authority_test_user.athority_mail_key, @mail_authority_test_user.email.upcase), @mail_authority_test_user, message: "User.athority_mail не прошла проверка" 
    assert @mail_authority_test_user.reload.is_checked_email, "is_checked_email не обновился при поддтверждении email адреса"
    
    assert_nil User.athority_mail(@mail_authority_test_user.athority_mail_key, %{#{default_string}@fuckyou.com}), "User.athority_mail прошел проверку пользователь с неправильной связкой key, email"
    assert_nil User.athority_mail(@mail_authority_test_user.athority_mail_key, users(:customer).email), "User.athority_mail прошел проверку пользователь с чужим email"
  
    was = @mail_authority_test_user.reload.is_checked_email
    assert @mail_authority_test_user.update_attributes(email: %{#{default_string}@fuckyou.com}, control_password: "123456", update_type: "email"), "Не обновился"
    @mail_authority_test_user.reload
    assert_not @mail_authority_test_user.is_checked_email, "is_checked_email не стал false при обновлении почтового адреса был #{was} и сейчас #{@mail_authority_test_user.reload.is_checked_email}"
  end
  
  private 
  
  def update_secondary_attributes(user)
    prev_pwd = user.encrypted_password
    prev_email = user.email
    assert user.update_attributes(first_name: default_string, last_name: default_string, third_name: default_string, phone_number: default_string, post_index: default_numb), "Не удалось обновить вторичные атрибуты пользователя #{user.user_type_ru}"
    user.reload
    assert_equal user.encrypted_password, prev_pwd, message: "При обновлении вторичных данных был изменен пароль"
    assert_equal user.email, prev_email, message: "При обновлении вторичных данных был изменен email"
  end
  
  def set_user_type_on_create_with_creator_info_test(i_set, i_change, is_posible)
    u = User.create(email: %{#{default_string}@fuckyou.com}, password: @psw, password_confirmation: @psw, user_type_id: i_change.user_type_id, creator_email: i_set.email, creator_salt: i_set.salt)
    if !is_posible
      assert_equal u.user_type_id, User.default_user_type_id, "Удалось добавить пользователя с произвольным user_type_id = #{i_change.user_type_id} c информацией о создателе типа #{i_set.user_type}"
    else
      assert_equal u.user_type_id, i_change.user_type_id, "Не удалось добавить пользователя с произвольным user_type_id = #{i_change.user_type_id} c информацией о создателе типа #{i_set.user_type}"
    end
  end
  
  def set_user_type_on_create_without_creator_info_test(user)
    u = User.create(email: %{#{default_string}@fuckyou.com}, password: @psw, password_confirmation: @psw, user_type_id: user.user_type_id)
    assert u.user_type_id == User.default_user_type_id, "Удалось добавить пользователя с произвольным user_type_id = #{user.user_type_id} без информации о создателе"
  end
  
  def set_user_type_id_on_update(ur, ud, is_posible)
    u = User.new(email: %{#{default_string}@fuckyou.com}, password: @psw, password_confirmation: @psw)
    assert u.save, "Не удалось добавить пользователя при тестировании обновления user_type_id"
    type_before = u.user_type_id
    assert u.update_attributes(user_type_id: ud.user_type_id, creator_email: ur.email, creator_salt: ur.salt, password: nil), "Не удалось обновить пользователя при тестировании обновления user_type_id #{u.errors.full_messages}"
    u.reload
    if !is_posible
      assert_equal u.reload.user_type_id, type_before, "Удалось обновить user_type_id пользователя на произвольный user_type_id = #{ud.user_type_id}, с данными пользователя #{ur.user_type}"
    else
      assert_equal u.reload.user_type_id, ud.user_type_id, "Удалось обновить user_type_id пользователя на произвольный user_type_id = #{ud.user_type_id}, с данными пользователя #{ur.user_type}"
    end
  end
  
end

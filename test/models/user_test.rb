require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "Тест сохранения сохранения пароля" do
    user = User.new(email: %{#{default_string}@fuckyou.com}, password: "123456", password_confirmation: "123456")
    assert user.save, "Тест пользователь не сохранился"
    assert !user.encrypted_password.blank? && !user.salt.blank?, "Пароль не зашифровался"
    user = User.new(email: %{#{default_string}@fuckyou.com}, password: "#{default_numb}", password_confirmation: "#{default_numb}")
    assert_not user.save, "Удалось сохранить пользователя с неправельным подтверждением"
  end
  
  test "Тест обновления пароля" do
    psw_1 = "#{default_numb}"
    psw_2 = "#{default_numb}"
    user = User.new(email: %{#{default_string}@fuckyou.com}, password: psw_1, password_confirmation: psw_1)
    assert user.save, "Тест пользователь не сохранился"
    salt = user.salt
    e_psw = user.encrypted_password
    user.update_attributes(password: psw_2, password_confirmation: psw_2)
    assert_not e_psw == user.encrypted_password, "Пароль не обновился"
  end
  
  test "Тест правильности email адреса" do
    bad_mail = default_string
    good_mail = %{#{default_string}@fuckyou.com}
    psw = default_numb.to_s
    u = User.new(password: psw, password_confirmation: psw, email: bad_mail)
    assert_not u.save, "удалось сохранить email неверного формата #{bad_mail}"
    u = User.new(password: psw, password_confirmation: psw, email: good_mail)
    assert u.save, "не удалось сохранить email верного формата #{good_mail}"
    assert u.email == good_mail.downcase, "перед добавлением в БД почтовый адрес не преобразуется в нижний регистр"
  end
  
  test "Тест обновления email адреса на уже существующий" do
    mail_1 = %{#{default_string}@fuckyou.com}
    mail_2 = %{#{default_string}@fuckyou.com}
    psw = default_numb.to_s
    u_1 = User.new(password: psw, password_confirmation: psw, email: mail_1)
    assert u_1.save, "Тест пользователь 1 не сохранился"
    u_2 = User.new(password: psw, password_confirmation: psw, email: mail_2)
    assert u_2.save,  "Тест пользователь 2 не сохранился"
    assert_not u_2.update_attributes(email: mail_1), "Удалось обновить адрес электронной почты на адрес другого пользователя"
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
    assert c.user_type == "customer", "Имя 'customer' указанное в тесте, не соответствует имени полученному из модели #{c.user_type}" 
    assert m.user_type == "manager", "Имя 'manager' указанное в тесте, не соответствует имени полученному из модели #{m.user_type}" 
  end
  
  test "Тест на установку user_type_id при создании нового пользователя" do
    m = users(:manager)
    c = users(:customer)
    psw = default_numb.to_s
    
    u = User.create(email: %{#{default_string}@fuckyou.com}, password: psw, password_confirmation: psw)
    
    assert u.user_type_id == User.default_user_type_id, "user_type_id установленный по умолчанию #{u.user_type_id} не равен User.default_user_type_id = #{User.default_user_type_id}"
    
    u = User.create(email: %{#{default_string}@fuckyou.com}, password: psw, password_confirmation: psw, user_type_id: m.user_type_id)
    
    assert u.user_type_id == User.default_user_type_id, "Удалось добавить пользователя с произвольным user_type_id = #{m.user_type_id} без информации о создателе типа manager"
    
    u = User.create(email: %{#{default_string}@fuckyou.com}, password: psw, password_confirmation: psw, user_type_id: m.user_type_id, creator_email: m.email, creator_salt: m.salt)
    assert u.user_type_id == m.user_type_id, "НЕ удалось добавить пользователя с произвольным user_type_id = #{m.user_type_id} c информацией о создателе типа manager"
    
    u = User.create(email: %{#{default_string}@fuckyou.com}, password: psw, password_confirmation: psw, user_type_id: m.user_type_id, creator_email: c.email, creator_salt: c.salt)
    assert u.user_type_id == User.default_user_type_id, "Удалось добавить пользователя с произвольным user_type_id = #{m.user_type_id} c информацией о создателе типа customer"

  end
  
  test "Тест на установку user_type_id при обновлении пользователя" do
    m = users(:manager)
    c = users(:customer)
    psw = default_numb.to_s
    u = User.create(email: %{#{default_string}@fuckyou.com}, password: psw, password_confirmation: psw)
    
    u.update_attributes(user_type_id: m.user_type_id, creator_email: m.email, creator_salt: m.salt)
    assert u.user_type_id == m.user_type_id, "Не удалось обновить user_type_id пользователя на произвольный user_type_id = #{m.user_type_id} с данными пользователя manager" 
  
    u.update_attributes(user_type_id: c.user_type_id, creator_email: nil, creator_salt: nil)
    assert u.user_type_id == m.user_type_id, "Пользователю удалось обновить user_type_id на другой #{u.user_type_id}" 
    
    u.update_attributes(user_type_id: m.user_type_id, creator_email: c.email, creator_salt: c.salt)
    assert u.user_type_id == m.user_type_id, "Удалось обновить user_type_id пользователя на произвольный user_type_id = #{m.user_type_id}, с данными пользователя customer" 
    
  end
end

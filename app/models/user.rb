class User < ApplicationRecord
  attr_accessor :password,  :control_password, :current_password, :creator_salt, :creator_email, :update_type
  
  before_save :encrypt_password, :set_default_user_type#, :check_email_update
  before_validation :check_email_update
  before_validation :check_password_on_create, on: :create
  
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :password, :presence => {:message => "Введите пароль длинной 6-40 символов"},
					   :confirmation => {:message => "Введённый пароль не совпадает с подтверждением"},
					   :length => {:within => 6..40, :message => "Длина пароля должна быть не менее 6 и не более 40 знаков"},
					   allow_nil: true


  validates :email,  :presence => {:message => "Поле 'E-mail' не должно быть пустым"},
				    format: {with: email_regex, message: "Поле 'E-mail' не соответсвует формату адреса электронной почты 'user@mail-provider.ru'"},
				    uniqueness: {case_sensitive: false, message: "E-mail уже используется"}
            #:on => :create
  
  
  validate :check_control_password, on: :update, if: :is_pwd_or_email_update?
  
  def check_control_password 
    err_txt = password.nil? ? "Не правильно введён пароль" : "Не правильно введён прежний пароль"
    flag = true
    if !control_password.nil?
      flag = encrypt(control_password) == encrypted_password 
    else
      flag = false
    end
    errors.add(:control_password, err_txt) if !flag 
    
  end
  
  def self.default_user_type_id
    User.count == 0 ? 131313 : 500100
  end
  
  def self.user_types
    [
      {id: 500100, name: "customer", ru_name: 'Клиент'}, 
      {id: 131313, name: "admin", ru_name: 'Администратор'},
      {id: 100500, name: "manager", ru_name: 'Менеджер'},
      {id: 600600, name: "banned", ru_name: 'Заблокирован'}
    ]
  end
  
  def user_type_ru
    get_type[:ru_name]
  end
  
  def user_type
    get_type[:name]
  end
  #user_types end
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = User.find_by(email: email.downcase)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end
	def self.authenticate_with_salt(id, cookie_salt)
    user = find_by(id: id)
	  (user && user.salt == cookie_salt) ? user : nil
  end  
  
  def self.athority_mail(key, r_email)
    return nil if key.nil? || r_email.nil?
    return nil if (u = find_by(email: r_email.downcase)).nil?
    return nil if !(u.athority_mail_key == key) || u.is_checked_email
    u.update_attribute(:is_checked_email, true)
    return u
  end
  
  def athority_mail_key #шифрует пароль
    encrypt %{#{self.email}--#{self.created_at}}
  end

  private
  
  def editor_is_admin?
    u = User.find_by(salt: self.creator_salt, email: self.creator_email)
    return false if u.nil?
    return u.user_type == "admin"
  end
  
  def is_pwd_or_email_update?
    !password.blank? || email_changed?# and !email.blank?
  end
  
  def get_type
    t = User.user_types.first
    User.user_types.each {|i| return i if i[:id] == self.user_type_id}
    return t
  end
  
  def check_email_update #преобразует введённый email в нижний регистр, перед сохранением в БД
    email.downcase!
    self.is_checked_email = !email_changed? 
  end
  
  def check_password_on_create
    self.password = self.password_confirmation = "" if self.password.nil? 
  end
  
  def set_default_user_type #устанавливает тип пользователя по умолчанию, перед сохранением в БД
    return if user_type_id_was.nil? and !new_record? 
    default_value = new_record? ? User.default_user_type_id : user_type_id_was
    self.user_type_id = editor_is_admin? ? self.user_type_id : default_value
  end
  
  def encrypt_password
    self.salt = make_salt if new_record?
	  self.encrypted_password = encrypt(password) if !password.blank?
  end	
  
  def encrypt(string)
	  secure_hash("#{salt}--#{string}")
  end
  
  def make_salt 
	  secure_hash("#{Time.now.utc}--#{password}")
  end
  
  def secure_hash(string)
	  Digest::SHA2.hexdigest(string)
  end
  

  
end

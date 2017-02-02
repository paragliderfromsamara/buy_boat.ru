class User < ApplicationRecord
  attr_accessor :password,  :old_password, :current_password, :creator_salt, :creator_email
  
  before_save :encrypt_password, :set_default_user_type
  before_validation :make_to_lower_case_email
  
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :password, :presence => {:message => "Введите пароль длинной 6-40 символов"},
					   :confirmation => {:message => "Введённый пароль не совпадает с подтверждением"},
					   :length => {:within => 6..40, :message => "Длина пароля должна быть не менее 6 и не более 40 знаков"},
					   :on => :create


  validates :email,  :presence => {:message => "Поле 'E-mail' не должно быть пустым"},
				    format: {with: email_regex, message: "Поле 'E-mail' не соответсвует формату адреса электронной почты 'user@mail-provider.ru'"},
				    uniqueness: {case_sensitive: false, message: "E-mail уже используется"}
  
  def self.default_user_type_id
    User.count == 0 ? 100500 : 500100
  end
  
  def self.user_types
    [
      {id: 100500, name: "manager"},
      {id: 500100, name: "customer"}, 
      {id: 600600, name: "banned"}
    ]
  end
  
  def is_attribute?(attribute)
    user_type == send(attribute)
  end
  
  def user_type
    t = "customer"
    User.user_types.each {|i| return i[:name] if i[:id] == self.user_type_id}
    return t
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
  
  private
  

  
  def make_to_lower_case_email #преобразует введённый email в нижний регистр, перед сохранением в БД
    self.email.downcase!
  end
  
  def set_default_user_type #устанавливает тип пользователя по умолчанию, перед сохранением в БД
    return if user_type_id_was.nil? and !new_record? 
    creator = User.find_by(salt: self.creator_salt, email: self.creator_email)
    default_value = new_record? ? User.default_user_type_id : user_type_id_was
    if !creator.nil?
      self.user_type_id = (creator.user_type == "manager") ? self.user_type_id : default_value
    else
      self.user_type_id = default_value
    end
  end
  
  def encrypt_password
    self.salt = make_salt if new_record?
	  self.encrypted_password = encrypt(password) if !password.blank? or password_confirmation != password
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

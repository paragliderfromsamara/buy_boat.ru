module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
    return true
  end
  
  def current_user=(user)
    @current_user = user
  end
   
  def current_user
	  @current_user ||= user_from_remember_token
  end
  
  def user_type
  	if !current_user.nil?
  		@current_user.user_type
  	else
  		user_type = "guest"
  	end
  end

  def session_menu_items
    if signed_in?
      [
        {url: signout_path, name: "Выйти"},
        {url: my_path, name: "Кабинет"}
      ]
    else
      [
        {url: signin_path, name: "Вход"},
        {url: signup_path, name: "Регистрация"}
      ]
    end
  end
  private
    
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
    
  	def sign_out
      cookies.delete(:remember_token)
      self.current_user = nil
    end
	
    def signed_in?
      !current_user.nil?
    end
end
